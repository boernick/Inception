#!/bin/bash
set -e

# Directories
DATADIR="/var/lib/mysql"
SOCKET="/var/run/mysqld/mysqld.sock"
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Only initialise if database is empty
if [ ! -d "$DATADIR/mysql" ]; then
    echo "[MariaDB] Initialising Database..."
    mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db >/dev/null

    echo "[MariaDB] Starting temporary server..."
    mysqld_safe --datadir="$DATADIR" --socket="$SOCKET" &

    # Wait until MariaDB is ready
    until mariadb-admin --protocol=socket --socket="$SOCKET" ping --silent; do
        sleep 1
    done

    echo "[MariaDB] Creating Database and User..."
    # Read passwords from files (from .env or secrets)
    ROOT_PASS_FILE="/etc/mariadb/root_password"
    USER_PASS_FILE="/etc/mariadb/user_password"

    mariadb --protocol=socket --socket="$SOCKET" -u root <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat $ROOT_PASS_FILE)';
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '$(cat $USER_PASS_FILE)';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
SQL

    echo "[MariaDB] Shutting down temporary server..."
    mariadb-admin --protocol=socket --socket="$SOCKET" -uroot -p"$(cat $ROOT_PASS_FILE)" shutdown
    sleep 2
fi

echo "[MariaDB] Starting main server..."
exec mysqld_safe --datadir="$DATADIR" --socket="$SOCKET"
