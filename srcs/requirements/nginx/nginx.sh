#!/bin/bash

# Create the necessary directories
mkdir -p /var/www/html/static
mkdir -p /var/www/html/wordpress

# Copy index.html from the "Safe Zone" to the static folder
cp /etc/nginx/index.html /var/www/html/static/index.html

# Copy the SSL key from Docker secrets
cp /run/secrets/ssl_private_key /etc/ssl/private/nginx-selfsigned.key

# Set ownership permissions
chown -R www-data:www-data /var/log/nginx
chown -R www-data:www-data /var/www/html

# Debugging logs: Link Nginx logs to stdout and stderr
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

# Start Nginx
exec nginx -g "daemon off;"
