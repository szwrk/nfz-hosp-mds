source_env:
	source ~/etl/app/env/.env
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
	
