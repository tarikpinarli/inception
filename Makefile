COMPOSE_FILE = ./srcs/docker-compose.yml

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	DATA_PATH = /Users/tarikpinarli/data
else
	DATA_PATH = /home/tpinarli/data
endif

all: up

# Create the data directories and start the containers
up:
	@echo "Detected OS: $(UNAME_S)"
	@echo "Using Data Path: $(DATA_PATH)"
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@if [ ! -f ./srcs/.env ]; then \
		echo "Setup: Copying .env.sample to .env..."; \
		cp ./srcs/.env.sample ./srcs/.env; \
	fi
	@echo "Starting containers..."
	@DATA_PATH=$(DATA_PATH) docker compose -f $(COMPOSE_FILE) up -d --build

# Stop the containers
down:
	@echo "Stopping containers..."
	@DATA_PATH=$(DATA_PATH) docker compose -f $(COMPOSE_FILE) down

clean:
	@echo "Cleaning Docker resources..."
	@DATA_PATH=$(DATA_PATH) docker compose -f $(COMPOSE_FILE) down -v

# Deep clean: remove images, volumes, and networks
fclean: clean
	@echo "Deep cleaning (Pruning system + Deleting Data)..."
	@docker system prune -af
	@echo "Deleting data at $(DATA_PATH)..."
	@# Sudo is usually needed on Linux, might ask for password on Mac
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@echo "Project reset complete."

re: fclean all

.PHONY: all up down clean fclean re
