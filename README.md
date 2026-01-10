*This project has been created as part of the 42 curriculum by nboer.*

# Inception

## Description
Inception is a system administration and DevOps project that deploys a complete WordPress infrastructure using Docker and Docker Compose.

The stack consists of:
- Nginx as HTTPS reverse proxy
- PHP-FPM running WordPress
- MariaDB as the database
- Docker volumes, networks and secrets for persistence and security

Each service runs in its own container and communicates through a private Docker network. All persistent data is stored on the host using bind-mounted volumes.

The final website is available at:
https://<username>.42.fr

## Architecture
Internet → Nginx (HTTPS) → WordPress (PHP-FPM) → MariaDB  
Only Nginx is exposed to the outside. WordPress and MariaDB are internal.

## Instructions

### Requirements
Docker, Docker Compose, GNU Make, Linux

### Usage
This project is controlled through a Makefile.
All data is stored in: /home/$USER/data

Available commands:
make Creates required folders, builds images and starts all containers
make setup - Creates the data directories
make build - Builds all Docker images
make up - Starts the containers
make down - Stops the containers
make clean - Stops containers and removes volumes (deletes all data)

Once running, open:
https://nboer.42.fr

## Project Design
Nginx handles HTTPS and forwards requests to WordPress via PHP-FPM. WordPress connects to MariaDB to store content. All services are isolated in containers and connected through a private Docker network.

               Internet
                   |
               HTTPS (443)
                   |
            +--------------+
            |    NGINX     |
            |  SSL + Proxy |
            +--------------+
                    |
                    | FastCGI (port 9000)
                    |
            +----------------+
            |   WordPress    |
            |    PHP-FPM     |
            +----------------+
                    |
                    | MySQL (3306)
                    |
            +----------------+
            |    MariaDB     |
            |   Database     |
            +----------------+

  All containers are connected through a private Docker network (mynetwork)
  Only NGINX is exposed to the host

Bind-mounted volumes are used for:
- WordPress files: /home/$USER/data/www/html
- MariaDB data: /home/$USER/data/db
- Nginx logs: /home/$USER/data/logs/nginx

SSL certificates are stored using Docker Secrets and mounted inside the Nginx container at runtime.

## Technical Choices
Virtual Machines vs Docker  
Docker is lightweight, fast and shares the host kernel, unlike virtual machines which run full operating systems.

Secrets vs Environment Variables  
Secrets are encrypted and mounted as files, while environment variables are visible in plain text. SSL keys use secrets, database credentials use environment variables.

Docker Network vs Host Network  
Docker networks isolate containers and provide internal DNS. Only Nginx is exposed to the host.

Volumes vs Bind Mounts  
Bind mounts map directly to host folders, making data easy to inspect and persist outside containers.

## Resources
Docker, Docker Compose, Nginx, MariaDB, WordPress and WP-CLI documentation.
AI tools were used for documentation lookup, architecture understanding and debugging assistance. All implementation and testing were done by the student.

## Result
This project delivers a secure, persistent, production-style WordPress deployment using containerized microservices, orchestrated by docker compose.
