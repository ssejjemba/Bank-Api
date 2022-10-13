APP = github.com/ssejjemba/simplebank
GOBASE = $(shell pwd)
GOBIN = $(GOBASE)/build/bin
LINT_PATH = $(GOBASE)/build/lint

postgres:
	docker run --name postgres14 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=my_post -d postgres:14-alpine

createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres14 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:my_post@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:my_post@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:my_post@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:my_post@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -build_flags=--mod=mod -destination db/mock/store.go github.com/ssejjemba/simplebank/db/sqlc Store

deps: ## Fetch required dependencies
	go mod tidy -compat=1.17
	go mod download

lint: ## Linter for developers
	$(LINT_PATH)/golangci-lint run --timeout=5m -c .golangci.yml

install-golangci: ## Install the correct version of lint
	GOBIN=$(LINT_PATH) go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.46.2

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock deps lint install-golangci