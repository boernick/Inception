FROM debian:stable

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

# Prepare necessary directories and set permissions
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 1777 /run/mysqld

# Ensure symlink for socket file
RUN ln -s /var/lib/mysql/mysql.sock /var/run/mysqld/mysqld.sock

# Copy script to container and make it executable
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

# Expose port for MariaDB
EXPOSE 3306

# Set the entry point to run the MariaDB setup script
ENTRYPOINT ["sh", "/usr/local/bin/mariadb.sh"]
