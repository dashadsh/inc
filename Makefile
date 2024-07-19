# docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
COMPOSE_FILE := ./srcs/docker-compose.yml
ENV_FILE := ./srcs/.env
WORDPRESS_DATA := /home/${USER}/data/wordpress/
MARIADB_DATA := /home/${USER}/data/mariadb/

DC := docker-compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE)

.PHONY: all dir ssl up build down re clean prune rmi rmv fclean

all: dir up

dir:
	chmod +x ./srcs/requirements/tools/make_dir.sh
	bash ./srcs/requirements/tools/make_dir.sh

ssl:
	chmod +x ./srcs/requirements/nginx/tools/ssl.sh
	bash ./srcs/requirements/nginx/tools/ssl.sh

up:
	$(DC) up -d

build:
	$(DC) up --build -d

down:
	$(DC) down

re: down build

rmi:
	docker images -q | xargs -r docker rmi -f

rmv:
	$(DC) down -v

prune:
	docker container prune -f
	docker network prune -f
	docker volume prune -f
	docker image prune -a -f
#       docker system prune -a --volumes # combines all commands above

clean: down
#clean: down
#	sudo rm -rf /home/${USER}/data

fclean: down
#fclean: down prune clean
