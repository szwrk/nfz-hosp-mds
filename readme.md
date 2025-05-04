# Healthcare Data Project
## About
Full selfhosted infrastructure.
Full data engineering stack

## Docs
[Open Docs](docs/docs.md)

## Data Enginnering Features
- Unit tests (dbt)
- Data Dictionary (dbt)
- Lineage (Airflow, dbt)

## All Components & Tools
**Infra**
- [x] Docker-Compose 
    - Containers
        - Apache Airflow,
        - Apache Superset
        - Postgres,
        - Oracle,
        - my Utils
- Dockerfile (Utils container)
    - Content
        - DBT
        - Liquibase
        - SSH
        - DB Clients
- Linux Debian

**Orchestration**
- [x] Apache Airflow
    - DAG 1
        - SSHOperators
        - BranchOperators
        - PythonOperators
        - etc
**ETL**
- [x] Extraction & Load, PySpark
- [x] Transformation,
    - dbt
    - Postgres

## Analyzing & Visualisation
- File Validation
     - JupiterNotebook & bash
- Exploratory Data Analysis
    - First EDA, explore raw CSV (JupiterNb, DuckDb, SQL)
    - Second EDA, after loading into DWH, histograms (JupiterNb, Pandas, Seaborn)
- Dashboard
    - Apache Superset

**DWH**
- Stage: Postgres

**CI/CD & Automation**   
- Makefile
- GIT
- Liquibase

**Scripts**
- SQL scripts
- Python
- bash

## Books
--todo