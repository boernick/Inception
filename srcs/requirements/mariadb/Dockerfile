FROM debian:stable

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

RUN mkdir -p /var/run/mysqld;  
RUN chown -R mysql:mysql /var/run/mysqld;  
RUN chmod 1777 /run/mysqld;

# Ensure symlink to /var/run/mysqld/mysqld.sock for local connections
RUN ln -s /var/lib/mysql/mysql.sock /var/run/mysqld/mysqld.sock

COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

ENTRYPOINT ["sh", "/usr/local/bin/mariadb.sh"]


# Copy settings files - has to go after ensuring symlink
# COPY mariadb.cnf /etc/mysql/my.cnf
# COPY mariadb.sql /etc/mysql/mariadb.sql.template
# COPY mariadb.sh  /etc/mysql/mariadb.sh