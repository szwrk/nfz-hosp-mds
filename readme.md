# Healthcare Data Project
## About
End-to-end data engineering project based on Polish healthcare hospitalization data (21M+ records). Fully self-hosted infrastructure with modular architecture and reproducible pipelines.

## Project Documentation
- [Open Docs](docs/docs.md)
- [Glossary](docs/glossary.md)
- [Structure tree](docs/tree.md)

## Data Engineering Features
- Unit tests (dbt)
- Data Dictionary (dbt)
- Lineage (Airflow, dbt)

## All Components & Tools
**Infra**
- Docker-Compose 
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
- Apache Airflow
    - DAG #1, Pipeline
        - SSHOperators
        - BranchOperators
        - PythonOperators
        - etc
**ETL**
- Extraction & Load, PySpark
- Transformation,
    - dbt
    - Postgres

## Data Layers
- Raw CSV, original flat files
- Stage, raw data loaded into Postgres
- Core models,  dbt transformations
    - Bronze,  initial cleaning & standardization
    - Silver, cleaned & structured models
    - Gold,  aggregated or business-ready models

## Analyzing & Visualisation
- File Validation
     - JupyterNotebook & bash
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
    - hooks pre-commit & pre-push
- Liquibase

**Scripts**
- SQL scripts
- Python
- bash

## References
**Books**
[ PL ]
- Inżynieria danych w praktyce, J. Reis
- Zaawansowana Analiza Danych, G. Mount
- SQL for Data Analysis, C. Tanimura

**Video courses**
- DBT 1x
- Airflow 2x

**Others**
:)