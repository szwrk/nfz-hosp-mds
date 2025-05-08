from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.exceptions import AirflowFailException
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python import ShortCircuitOperator
from airflow.operators.python import BranchPythonOperator
from airflow.operators.empty import EmptyOperator
from airflow.providers.ssh.operators.ssh import SSHOperator
from airflow.utils.task_group import TaskGroup
from airflow.utils.dates import days_ago
from airflow.models.param import Param
from airflow.models import Variable
import os
from datetime import timedelta

params = {
    "users": Param(
        default=["sysaw"],
        type="array",
        description="Create users with name:"
    ),
    "run_initial_db_setup": Param(
        default=False,
        type="boolean",
        description="Run one-time DB initialization scripts (users, roles, grants, etc.)"
    )
}

def check_source():
    if not os.path.exists('/app/data'):
        raise AirflowFailException("/app/data directory does not exist!")
    if not any(f.endswith('.csv') for f in os.listdir('/app/data')):
        raise AirflowFailException("No source CSV files detected!")
    
def find_csv_files(**kwargs):
    files = [f"/app/data/{f}"
             for f in os.listdir('/app/data')
             if f.endswith('.csv')             
    ]
    print(f"Pushed files: {files}")
    kwargs['ti'].xcom_push(key='csv_list', value=files)

def log_files(**kwargs):
    files = kwargs['ti'].xcom_pull(key='csv_list', task_ids='csv.find_csv_files')
    if not files:
        print("No files found.")
        return
    print("Found CSV files")
    for f in files:
        print(f" - {f}")

def set_db_flag():
    Variable.set("db_setup_done", "True")

def fail_if_db_already_initialized(**kwargs):
    if kwargs['dag_run'].conf.get('run_initial_db_setup', False):
        if Variable.get("db_setup_done", default_var="False") == "True":
            raise AirflowFailException(
                "Warn: Initial setup already done. Aborting to prevent redundant execution of scripts!"
            )
    return True

def setup_branch(**kwargs):
    if kwargs['dag_run'].conf.get('run_initial_db_setup', True):
        return "setup_db_group.start_setup_db"
    else:
        return "skip_setup"

with DAG(
    "0_pipeline_etl",
    default_args={
        "owner": "Airflow",
        "retries": 0,
        "start_date": days_ago(1),
    },
    description="DAG 21m rows project",
    schedule_interval="@once",
    catchup=False,
    params=params,
    template_searchpath="/app/db/sql",
) as dag:

    with TaskGroup("csv") as csv:
        check_source_task = PythonOperator(
            task_id="check_datasource",
            python_callable=check_source)
        
        find_files = PythonOperator(
            task_id="find_csv_files",
            python_callable=find_csv_files,
        )

        log_found_files = PythonOperator(
            task_id="log_found_csv_files",
            python_callable=log_files,
        )

        check_source_task >> find_files >> log_found_files

    with TaskGroup("server_healthcheck_group") as server_healthcheck_group:
        data_utils_healthcheck = BashOperator(
            task_id="utils_service_healthcheck",
            bash_command='nc -zv utils 22 || { echo "Health check failder!"; exit 1; }',
            retries=0,
            retry_delay=timedelta(seconds=10),
        )

    with TaskGroup("connection_check_group") as connection_check_group:
        ssh_echo_check = SSHOperator(
            task_id="connection_utils_dummy",
            ssh_conn_id="utils",
            command='echo "Connected to SSH"',
        )     

    choose_optional_setup = BranchPythonOperator(
        task_id="choose_optional_setup",
        python_callable=setup_branch,        
    )
    

    with TaskGroup("setup_db_group") as setup_db_group:
     
        start_setup_db = EmptyOperator(task_id="start_setup_db")

        fail_on_redundant_setup_request = PythonOperator (
            task_id="fail_on_redundant_setup_request",
            python_callable=fail_if_db_already_initialized,
        )  

        test_list_sqls = BashOperator(task_id="test_path", bash_command="ls -lah /app/db/sql")

        config_db1 = PostgresOperator(
            task_id="config_db1",
            sql="00.sql",
            postgres_conn_id="postgres_dwh",
        )
        
        config_db2 = PostgresOperator(
            task_id="config_db2",
            sql="01.sql",
            postgres_conn_id="postgres_dwh",
        )

        sql_template = """
          {% for user in params.users %}
            CREATE ROLE {{ user }} LOGIN PASSWORD 'oracle';
            GRANT dataengineer TO {{ user }};
            GRANT USAGE ON SCHEMA hospital TO {{ user }};
            GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA hospital TO {{ user }};
            ALTER DEFAULT PRIVILEGES IN SCHEMA hospital GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO {{ user }};
            {% endfor %}
            """
        config_db3 = PostgresOperator(
            task_id="config_db3",
            sql=sql_template,
            postgres_conn_id="postgres_dwh",
        )

        end_setup_db = PythonOperator(
            task_id="mark_db_setup_done",
            python_callable=set_db_flag,            
        )

        start_setup_db >> fail_on_redundant_setup_request >> test_list_sqls >>config_db1 >> config_db2 >> config_db3 >> end_setup_db

    skip_setup = EmptyOperator(task_id="skip_setup")
    join_paths = EmptyOperator(task_id="join_paths", trigger_rule="none_failed_min_one_success")

    with TaskGroup("staging_migration_group") as staging_migration_group:
        start_migration = EmptyOperator(task_id="start_migration")

        check = SSHOperator(
            task_id="run_liquibase_version",
            ssh_conn_id="utils",
            command='cd /app/db/changelog/ && liquibase --version && liquibase validate',
        )

        update = SSHOperator(
            task_id="run_liquibase",
            ssh_conn_id="utils",
            command="cd /app/db/changelog/ && liquibase update",
        )

        end_migration = EmptyOperator(task_id="end_migration")
        start_migration >> check >> update >> end_migration

    end_dag = EmptyOperator(task_id="end_dag")
    
csv >> server_healthcheck_group >> connection_check_group
connection_check_group >> choose_optional_setup
choose_optional_setup >> start_setup_db
choose_optional_setup >> skip_setup
skip_setup >> join_paths
end_setup_db >> join_paths
join_paths >> start_migration
join_paths >> start_migration
end_migration >> end_dag


