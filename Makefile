clean-dwh:
	docker compose stop postgres_dwh
	docker compose up -d postgres_dwh

reset-oracle:
	docker-compose stop oracle-hc 
	docker-compose rm -f oracle-hc 
	docker-compose up -d oracle-hc 

restart-containers:
	docker-compose down && docker-compose up -d

ENV_FILE=./app/env/.env
rebuild-util:
	test -f $(ENV_FILE) || (echo "Missing env file!" && exit 1)
	ln -sf $(ENV_FILE) .env
	docker compose build utils
	docker compose up -d
restart-airflow:
	test -f $(ENV_FILE) || (echo "Missing env file!" && exit 1)
	ln -sf $(ENV_FILE) .env
	docker compose --env-file $(ENV_FILE) up -d --build airflow-webserver airflow-scheduler airflow-worker

start:
	docker compose --env-file $(ENV_FILE) up -d

rebuild:
	docker compose --env-file $(ENV_FILE) up -d --build