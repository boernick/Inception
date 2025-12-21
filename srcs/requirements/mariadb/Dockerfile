FROM debian:bookworm

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Create password files for root/user (from .env or secrets)
RUN mkdir -p /etc/mariadb && \
    echo "${MARIADB_ROOT_PASSWORD}" > /etc/mariadb/root_password && \
    echo "${MARIADB_PASSWORD}" > /etc/mariadb/user_password && \
    chmod 600 /etc/mariadb/*

# Copy configuration and startup script
COPY /tools/mariadb.cnf /etc/mysql/my.cnf
COPY /tools/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

HEALTHCHECK CMD mysqladmin ping -h localhost || exit 1

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]
