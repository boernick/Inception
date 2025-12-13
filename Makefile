# 42 Inception Docker Makefile - improved version

COMPOSE_DIR := srcs
USER_HOME := /home/$(USER)
DATA_DIR := $(USER_HOME)/data

.PHONY: all setup up down build clean

# Default target
all: setup up

# Directory creation with dependency tree
$(DATA_DIR):
	mkdir -p $(DATA_DIR)

$(DATA_DIR)/www: $(DATA_DIR)
	mkdir -p $(DATA_DIR)/www

$(DATA_DIR)/www/html: $(DATA_DIR)/www
	mkdir -p $(DATA_DIR)/www/html

$(DATA_DIR)/db: $(DATA_DIR)
	mkdir -p $(DATA_DIR)/db

$(DATA_DIR)/logs: $(DATA_DIR)
	mkdir -p $(DATA_DIR)/logs

$(DATA_DIR)/logs/nginx: $(DATA_DIR)/logs
	mkdir -p $(DATA_DIR)/logs/nginx

$(DATA_DIR)/logs/mariadb: $(DATA_DIR)/logs
	mkdir -p $(DATA_DIR)/logs/mariadb

# Setup all directories
setup: $(DATA_DIR) $(DATA_DIR)/www $(DATA_DIR)/www/html $(DATA_DIR)/db $(DATA_DIR)/logs $(DATA_DIR)/logs/nginx $(DATA_DIR)/logs/mariadb
	@echo "✅ Directories created:"
	@ls -ld $(DATA_DIR) $(DATA_DIR)/www/html $(DATA_DIR)/db $(DATA_DIR)/logs/nginx $(DATA_DIR)/logs/mariadb

# Build images
build:
	docker-compose -f $(COMPOSE_DIR)/docker-compose.yml build
	@echo "✅ Docker images built"

# Start containers
up: setup
	docker-compose -f $(COMPOSE_DIR)/docker-compose.yml up -d
	@echo "✅ Docker containers are up"

# Stop containers
down:
	docker-compose -f $(COMPOSE_DIR)/docker-compose.yml down
	@echo "⚠ Docker containers stopped"

# Remove containers and volumes
clean:
	docker-compose -f $(COMPOSE_DIR)/docker-compose.yml down -v
	@echo "🧹 Docker containers and volumes removed"
