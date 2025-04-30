# Project Healtcare Data
## About

## Data Buzzwords
- Orchestration / Data Pipeline, Apache Airflow
- Transformation, dbt ( _database tool_ )
- Validations, Great Expectactions

## Features
- anonimizacja sha2


## Components
- My Docker Compose
- Apache Airflow Compose
- Docker network: hc-network
- Automation (Linux)
  - Makefile

# Manual
## Users
- Airflow: arek/oracle
## Build
**Utils image requirment**
./project-data/utils/tmp
   - [Oracle Client - instantclient-basic.zip](https://www.oracle.com/database/technologies/instant-client/downloads.html)
   - [SQLLoader - instantclient-tools.zip](https://www.oracle.com/database/technologies/instant-client/downloads.html)

## Setup Utils
**Airflow SSHConnection**
.env | grep AIRFLOW_CONN

## Setup Project
1. Add lib /data/postgres.jar
2. Run init_db.sql (schema, user)
3. Create Raw table - Liquibase
4. Load data with PySpark
5. DBT

## EDA - notebooks
1. Raw data analysis

## Database - Notes
### Postgres
arek@srv2:~/project-data$ psql -h localhost -p 5432 -U postgres -d datamart
arek@srv2:~/project-data$ psql -h localhost -p 5432 -U sysaw -d datamart

### Oracle
**Docker Port forwarding**
docker ps port forwarding to 1521 so you can access by localhost
**Setup SQLCl**
echo 'export PATH=/opt/sqlcl/sqlcl/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
**Test connection**
sql sys/oracle@localhost:1521/xepdb1 as sysdba
**Issue: DB NOT OPEN during connection**
sql sys/oracle@localhost:1521 as sysdba
alter pluggable database datamart open;

**Validate tables**
select table_name from all_tables where owner = 'DM_NFZHOSP';
desc DM_NFZHOSP.HOSPITALIZACJE_CSV;
.