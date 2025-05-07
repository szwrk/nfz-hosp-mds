# Project Structure
```plaintext
.
├── airflow
│   ├── airflow.cfg
│   ├── airflow-webserver.pid
│   ├── dags
│   │   └── 0test.py
│   ├── plugins
│   └── webserver_config.py
├── app
│   ├── config
│   │   ├── create-user-airflow.sh
│   │   └── keys
│   │       ├── ssh
│   │       └── ssh.pub
│   ├── data
│   │   ├── data-demo
│   │   │   ├── demo_nfz_hospitalizations_2019-2021.csv
│   │   │   ├── demo_nfz_hospitalizations_2022.csv
│   │   │   └── jgp.csv
│   │   ├── hospitalizations_schema.yml
│   │   ├── jgp.csv
│   │   ├── jgp_schema.yml
│   │   ├── nfz_hospitalizations_2019-2021.csv
│   │   └── nfz_hospitalizations_2022.csv
│   ├── db
│   │   ├── changelog
│   │   │   ├── changelog.xml
│   │   │   ├── changeset-01-create-raw-hospitalizations.xml
│   │   │   ├── changeset-02-create-etl-meta.xml
│   │   │   ├── changeset-03-update-raw-hospitalizations.xml
│   │   │   └── liquibase.properties
│   │   ├── postgresql.jar
│   │   └── sql
│   │       ├── 00.sql
│   │       ├── 01.sql
│   │       └── 02.j2.old
│   ├── env
│   └── pipeline
│       └── extract.py
├── docker-compose.yml
├── docs
│   ├── connection.png
│   ├── diagram.uml
│   ├── docs.md
│   ├── glossary.md
│   └── tree.md
├── eda
│   ├── eda-raw.ipynb
│   └── file-inspection.ipynb
├── etl.code-workspace
├── img
│   └── utils
│       ├── Dockerfile
│       └── tmp
│           ├── instantclient-basic.zip
│           └── instantclient-tools.zip
├── Makefile
├── notes.md
├── readme.md
└── todo.md

19 directories, 41 files
```
