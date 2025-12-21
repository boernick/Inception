#!/bin/bash
set -e

DATADIR="/var/lib/mysql"
SOCKET="/var/run/mysqld/mysqld.sock"

mkdir -p /run/mysqld "$DATADIR"
chown -R mysql:mysql /run/mysqld "$DATADIR"

if [ ! -d "$DATADIR/$MARIADB_DATABASE" ]; then
	echo "[MariaDB] Initialising database..."
	mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db > /dev/null

	echo "[MariaDB] Starting temporary server..."
	mysqld_safe --datadir="$DATADIR" --socket="$SOCKET" &
	
	until mariadb-admin --protocol=socket --socket="$SOCKET" ping --silent; do
		sleep 1
	done

	echo "[MariaDB] Creating database and users..."
	mariadb --protocol=socket --socket="$SOCKET" -u root -p"${MARIADB_ROOT_PASSWORD}" <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
SQL

	echo "[MariaDB] Shutting down temporary server..."
	mariadb-admin --protocol=socket --socket="$SOCKET" -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown
	sleep 2
fi

echo "[MariaDB] Starting MariaDB..."
exec mysqld_safe --datadir="$DATADIR" --socket="$SOCKET"
