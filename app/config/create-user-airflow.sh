#!/bin/bash
docker exec -i project-data_airflow-webserver_1 bash <<EOF
airflow users create \
  --username airflow \
  --password airflow \
  --firstname Arek \
  --lastname Admin \
  --role Admin \
  --email arek@example.com
EOF
