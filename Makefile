# Path to the compose file
COMPOSE_FILE = ./srcs/docker-compose.yml
# Variables for paths (Cleaner)
DATA_PATH = /home/tpinarli/data
# Default target
all: up

# Create the data directories and start the containers
# Note: "docker compose" (space) instead of "docker-compose" (hyphen)
up:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@if [ ! -f ./srcs/.env ]; then \
		echo "Setup: Copying .env.sample to .env..."; \
		cp ./srcs/.env.sample ./srcs/.env; \
	fi
	@echo "Starting containers..."
	@docker compose -f $(COMPOSE_FILE) up -d --build

# Stop the containers
down:
	@echo "Stopping containers..."
	@docker compose -f $(COMPOSE_FILE) down

# Stop containers and remove volumes (clean)
clean:
	@echo "Cleaning Docker resources..."
	@docker compose -f $(COMPOSE_FILE) down -v

# Deep clean: remove images, volumes, and networks
fclean: clean
	@echo "Deep cleaning (Pruning system + Deleting Data)..."
	@docker system prune -af
	@# This sudo is required because Docker runs as root and owns these files
	@sudo rm -rf $(DATA_PATH)/mariadb/*
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@echo "Project reset complete."

# Rebuild everything
re: fclean all

.PHONY: all up down clean fclean re
