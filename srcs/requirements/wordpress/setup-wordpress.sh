#!/bin/sh
set -e

echo $MARIADB_DATABASE
echo $MARIADB_USER
echo $MARIADB_PASSWORD
echo $MARIADB_HOST

chown -R www-data:www-data /var/www
mkdir -p /etc/php

# Install wp-cli if not already installed
if [ ! -f /etc/php/wp ]; then
    curl -o /etc/php/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x /etc/php/wp-cli.phar
    mv /etc/php/wp-cli.phar /etc/php/wp
fi

# Download WordPress if not present
if [ ! -f "/var/www/html/wp-settings.php" ]; then
    echo "Downloading WordPress..."
    su -s /bin/bash www-data \
        -c "/etc/php/wp --allow-root core download --path='/var/www/html'"
    # Generate wp-config.php from environment variables
    su -s /bin/bash www-data \
        -c "/etc/php/wp config create \
            --dbname='${MARIADB_DATABASE}' \
            --dbuser='${MARIADB_USER}' \
            --dbpass='${MARIADB_PASSWORD}' \
            --dbhost='${MARIADB_HOST}' \
            --allow-root \
            --path='/var/www/html'"
else
    echo "WordPress already downloaded."
fi

# Wait until MariaDB is ready
while ! mariadb -h "$MARIADB_HOST" -P "$MARIADB_PORT" -u "$MARIADB_USER" -p"$MARIADB_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    echo "MariaDB not ready yet... waiting"
    sleep 2
done

echo "MariaDB connection established"

# Check if WordPress is already installed by inspecting wp_users table
users_table_exists=$(mariadb -h "$MARIADB_HOST" -P "$MARIADB_PORT" -u "$MARIADB_USER" -p"$MARIADB_PASSWORD" \
    -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='${MARIADB_DATABASE}' AND table_name='wp_users';" -ss)

if [ "$users_table_exists" -eq 0 ]; then
    echo "Installing WordPress..."
    su -s /bin/bash www-data \
        -c "/etc/php/wp --allow-root core install \
            --path='/var/www/html' \
            --admin_user='${WP_ADMIN_USER}' \
            --admin_password='${WP_ADMIN_PASSWORD}' \
            --admin_email='admin@wpepping.42.fr' \
            --url='http://wpepping.42.fr' \
            --title='Inception'"
else
    echo "WordPress already installed."
fi

# Start PHP-FPM in foreground
exec php-fpm8.4 --nodaemonize
