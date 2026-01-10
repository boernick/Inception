#!/bin/sh
# Exit immediately if a command exits with a non-zero status
set -e

# Ensure correct permissions on the volume
chown -R www-data:www-data /var/www

echo "Waiting for MariaDB..."
until mariadb --skip-ssl -h "$MARIADB_HOST" -u "$MARIADB_USER" -p"$MARIADB_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1; do
    echo "MariaDB not ready yet... waiting"
    sleep 2
done
echo "MariaDB connection established"

# Download WordPress if not already present
if [ ! -f "/var/www/html/wp-load.php" ]; then
    echo "Downloading WordPress..."
    su -s /bin/sh www-data -c "wp core download --path='/var/www/html'"
fi

# Create wp-config.php using WP-CLI
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Creating wp-config.php..."
    su -s /bin/sh www-data -c "wp config create \
        --path='/var/www/html' \
        --dbname='$MARIADB_DATABASE' \
        --dbuser='$MARIADB_USER' \
        --dbpass='$MARIADB_PASSWORD' \
        --dbhost='$MARIADB_HOST' \
        --skip-check"
fi

# Install WordPress if not already installed
if ! su -s /bin/sh www-data -c "wp core is-installed --path='/var/www/html'"; then
    echo "Installing WordPress..."
    su -s /bin/sh www-data -c "wp core install \
        --path='/var/www/html' \
        --url='nboer.42.fr' \
        --title='Inception' \
        --admin_user='$WP_ADMIN_USER' \
        --admin_password='$WP_ADMIN_PASSWORD' \
        --admin_email='admin@nboer.42.fr' \
        --skip-email"
    
    echo "Creating secondary user..."
    su -s /bin/sh www-data -c "wp user create \
        $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --path='/var/www/html'"
else
    echo "WordPress already installed."
fi

# Start PHP-FPM
echo "Starting PHP-FPM..."
# -F keeps it in the foreground so the container doesn't exit
exec php-fpm8.2 -F
