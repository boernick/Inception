#!/bin/sh
set -e

# Only run if WordPress is not already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    # Generate wp-config.php
    wp config create \
        --dbname="$MARIADB_DATABASE" \
        --dbuser="$MARIADB_USER" \
        --dbpass="$MARIADB_PASSWORD" \
        --dbhost="$MARIADB_HOST:$MARIADB_PORT" \
        --allow-root

    # Install WordPress
    wp core install \
        --url="https://nboer.42.fr:8443" \
        --title="Inception WP" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="nboer@42.fr" \
        --skip-email \
        --allow-root
fi

exec php-fpm8.4 -F
