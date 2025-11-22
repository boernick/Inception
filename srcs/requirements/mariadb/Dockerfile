FROM debian:stable

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]
