set -e

# Ensure MySQL data directory has the right ownership
chown -R mysql:mysql /var/lib/mysql

# Initialize database if it's not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --ldata=/var/lib/mysql

    # Start MariaDB without networking initially
    mysqld_safe --skip-networking --user=mysql &
    sleep 5

    # Run SQL commands to create database, user, and set root password
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # Kill MariaDB instance after setup
    killall mysqld
    sleep 2
fi

# Start MariaDB normally after setup
exec mysqld_safe --user=mysql
