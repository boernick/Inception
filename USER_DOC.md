# User Documentation – Inception
This document is written for people who want to USE the website or operate the system,
not to modify or develop it.

It explains how to run the project, access the site, and check that everything works.

## What does this project provide?
This project provides a secure WordPress website hosted on Docker containers.

It includes:
- A public website
- An administration interface
- A database storing all content
- HTTPS encryption

The website is available at:
https://nboer.42.fr

## Starting and stopping the system
All operations are done with the Makefile.

Start all services: make
Stop all services: make down
Completely remove everything (including data): make clean

## Accessing the website
Open a browser and go to:
https://nboer.42.fr

To access the WordPress admin panel:
https://nboer.42.fr/wp-admin

Use the WordPress admin username and password defined in the `.env` file.

## Where are the passwords?
All usernames and passwords are stored in the `.env` file located at the root of the project.

It contains:
- Database credentials
- WordPress admin account
- WordPress secondary user

SSL certificates are stored securely as Docker secrets and are not visible to users.

## How to check if everything is working
Check that the website loads in your browser.

You can also verify that all containers are running:
docker ps

To see service logs:
docker logs nginx  
docker logs wordpress  
docker logs mariadb  

If all three containers are running and the website loads, the system is working.

## Where is the website data?
Website files and database data are stored on the host in: /home/$USER/data
WordPress files: /home/$USER/data/www/html
Database: /home/$USER/data/db
