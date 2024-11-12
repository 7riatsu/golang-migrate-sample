.PHONY: up down migrate-up migrate-down create-migration migrate-status migrate-force migrate-goto migrate-up-one migrate-down-one

include .env
export

up:
	docker-compose up -d

down:
	docker-compose down

# マイグレーション用のデータベース接続URL
DATABASE_URL=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@tcp(db:3306)/${MYSQL_DATABASE}

# マイグレーションファイルの作成
create-migration:
	@if [ -z "$(name)" ]; then \
		echo "Error: name parameter is required. Usage: make create-migration name=migration_name"; \
		exit 1; \
	fi
	docker-compose run --rm migrate \
		create -ext sql -dir /migrations/schema -format "20060102150405" $(name)

# 全てのマイグレーションを実行
migrate-up:
	docker-compose run --rm migrate \
		-path /migrations/schema \
		-database "${DATABASE_URL}" \
		up

# 全てのマイグレーションを巻き戻し
migrate-down:
	docker-compose run --rm migrate \
		-path /migrations/schema \
		-database "${DATABASE_URL}" \
		down

# 1つ先のバージョンにマイグレーション
migrate-up-one:
	docker-compose run --rm migrate \
		-path /migrations/schema \
		-database "${DATABASE_URL}" \
		up 1

# 1つ前のバージョンに戻す
migrate-down-one:
	docker-compose run --rm migrate \
		-path /migrations/schema \
		-database "${DATABASE_URL}" \
		down 1

# 特定のバージョンまでマイグレーション
migrate-goto:
	@if [ -z "$(version)" ]; then \
		echo "Error: version parameter is required. Usage: make migrate-goto version=1"; \
		exit 1; \
	fi
	docker-compose run --rm migrate \
		-path /migrations/schema \
		-database "${DATABASE_URL}" \
		goto $(version)

# マイグレーションのステータス確認
migrate-status:
	docker-compose run --rm migrate \
		-path /migrations/schema \
		-database "${DATABASE_URL}" \
		version

# マイグレーションのバージョンを強制的に設定（エラー時の復旧用）
migrate-force:
	@if [ -z "$(version)" ]; then \
		echo "Error: version parameter is required. Usage: make migrate-force version=1"; \
		exit 1; \
	fi
	docker-compose run --rm migrate \
		-path /migrations/schema \
		-database "${DATABASE_URL}" \
		force $(version)
