# Path to the compose file
COMPOSE_FILE = ./srcs/docker-compose.yml

# Default target
all: up

# Create the data directories and start the containers
# Note: "docker compose" (space) instead of "docker-compose" (hyphen)
up:
	@mkdir -p /home/tpinarli/data/wordpress
	@mkdir -p /home/tpinarli/data/mariadb
	@if [ ! -f ./srcs/.env ]; then \
		echo "Copying .env.sample to .env..."; \
		cp ./srcs/.env.sample ./srcs/.env; \
	fi
	@docker compose -f ./srcs/docker-compose.yml up -d --build

# Stop the containers
down:
	@docker compose -f $(COMPOSE_FILE) down

# Stop containers and remove volumes (clean)
clean:
	@docker compose -f $(COMPOSE_FILE) down -v

# Deep clean: remove images, volumes, and networks
fclean: clean
	@docker system prune -af

# Rebuild everything
re: fclean all

.PHONY: all up down clean fclean re
