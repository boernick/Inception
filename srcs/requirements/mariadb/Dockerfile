FROM debian:stable

RUN apt-get update
RUN apt-get install -y mariadb-server
RUN apt-get install -y gettext
RUN apt-get clean

COPY tools/mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["mariadb.sh"]
