include .env
export

export PROJECT_ROOT=$(shell pwd)

env-up:
	docker compose up -d todoapp-postgres
env-down:
	docker compose down todoapp-postgres
env-cleanup:
	@read -p "очистить все volume файлы окружения? опасность потрять все данные. [y/N]: " ans;\
	if  ["$$ans" = "y"]; then \
		docker compose down todoapp-postgres port-forwarder && \
		rm -rf out/pgdata && \
		echo "файлы оркужения очищены"; \
	else \
		echo "очистка окружения отменена"; \
	fi
env-port-forward:
	@docker compose up -d port-forwarder
env-port-close:
	@docker compose down port-forwarder

migrate-create:
# 	@if [ -z "$(seq)"]; then \
# 		echo "отсутствует необходимый параметр seq"; \
# 		exit 1; \
# 	fi;\
# 	docker compose run --rm todoapp-postgres-migrate \
# 		create \
# 		-ext sql \
# 		-dir /migrations \
# 		-seq "$(seq)"
	ifndef seq
		$(error отсутствует необходимый параметр seq. Пример: make migrate-create seq=init)
	endif
		docker compose run --rm todoapp-postgres-migrate create -ext sql -dir /migrations -seq "$(seq)"


migrate-up:
	make migrate-action action=up
migrate-down:
	make migrate-action action=down
migrate-action:
	docker compose run  --rm todoapp-postgres-migrate \
			-path /migrations \
			-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todoapp-postgres:5432/${POSTGRES_DB}?sslmode=disable \
			"$(action)"


# @export LOGGER_FOLDER=${PROJECT_ROOT}/out/logs && 

# todoapp-run:
# 	@export LOGGER_FOLDER  = ./out/logs && \
# 	go mod tidy && \
# 	go run cmd/todoapp/main.go

logs-cleanup:
	@read -p "очистить все log файлы? опасность потрять ЛОГИ. [y/N]: " ans;\
	if  ["$$ans" = "y"]; then \
		docker compose down todoapp-postgres port-forwarder && \
		rm -rf out/pgdata && \
		echo "файлы логов очищены"; \
	else \
		echo "очистка логов отменена"; \
	fi

todoapp-run:
	@go mod tidy
	
	set POSTGRES_HOST=localhost& set LOGGER_FOLDER=./out/logs& go run cmd/todoapp/main.go