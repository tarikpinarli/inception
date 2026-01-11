# Path to the compose file
COMPOSE_FILE = ./srcs/docker-compose.yml

# Default target
all: up

# Create the data directories and start the containers
# Note: "docker compose" (space) instead of "docker-compose" (hyphen)
up:
	@mkdir -p /home/tpinarli/data/wordpress
	@mkdir -p /home/tpinarli/data/mariadb
	@docker compose -f $(COMPOSE_FILE) up -d --build

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
