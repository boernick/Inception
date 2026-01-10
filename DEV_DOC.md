# Developer Documentation – Inception
This document is for developers or administrators who want to understand, maintain,
or modify the infrastructure.

It explains how the stack is built, configured, and where data and services live.

## Project structure
This project uses Docker Compose to orchestrate three services:
- nginx
- wordpress
- mariadb

The main configuration is located in:
srcs/docker-compose.yml

Each service has its own Dockerfile, configuration files, and startup scripts.

## Environment setup
Before running the project, the following must be prepared:

- Docker and Docker Compose installed
- GNU Make installed
- A `.env` file at the project root
- SSL certificates inside requirements/nginx/keys/

The `.env` file must define:
MARIADB_DATABASE  
MARIADB_USER  
MARIADB_PASSWORD  
MARIADB_ROOT_PASSWORD  
WP_ADMIN_USER  
WP_ADMIN_PASSWORD  
WP_USER  
WP_USER_PASSWORD  
WP_USER_EMAIL  

## Building and running
The Makefile is the main control interface.

make - Creates all directories, builds all images, and starts all containers.
make - build Builds all Docker images.
make up - Starts containers without rebuilding.
make down - Stops all containers.
make clean - Stops all containers and removes volumes.

## Docker and networking
All containers are connected through a custom Docker network called `mynetwork`.
Only Nginx exposes ports to the host.
WordPress and MariaDB are accessible only inside the Docker network.

## Data persistence
The project uses bind mounts for persistent data:

WordPress: /home/$USER/data/www/html
MariaDB: /home/$USER/data/db
Nginx logs: /home/$USER/data/logs/nginx

Because these are bind mounts, deleting containers does not delete data unless volumes are removed.

## Secrets
SSL certificates are provided as Docker secrets:
- ssl_private_key
- ssl_certificate

They are mounted into the Nginx container at runtime and never stored in Docker images.

## Container management
List containers:
docker ps

View logs:
docker logs nginx  
docker logs wordpress  
docker logs mariadb  

Restart a service:
docker restart wordpress

Rebuild a service:
docker compose -f srcs/docker-compose.yml build wordpress
