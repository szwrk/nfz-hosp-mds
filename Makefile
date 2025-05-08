source_env:
	. ~/etl/app/env/.env

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

TREE_FILE = docs/tree.md
tree:
	cd ~/etl && { \
		echo '# Project Structure' > $(TREE_FILE); \
		echo '```plaintext' >> $(TREE_FILE); \
		tree -I '__pycache__|logs|venv|git|.idea' >> $(TREE_FILE); \
		echo '```' >> $(TREE_FILE); \
	}
	cat $(TREE_FILE)
	git add $(TREE_FILE)
	git commit -m"chore: autorender tree"
	
validate-schema:
	docker exec utils bash -c "cd /app/db/changelog && liquibase validate"  2>&1 | tail -n +34

update-schema:
	docker exec utils bash -c "cd /app/db/changelog && liquibase update"  2>&1 | tail -n +34

clear-checksums:
	docker exec utils bash -c "cd /app/db/changelog && liquibase clearCheckSums"

connect-pg:
	docker exec -ti postgres_dwh bash -c "psql -h localhost -p 5432 -U sysaw -d datamart"