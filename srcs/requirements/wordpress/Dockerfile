FROM debian:stable

RUN apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	curl \
	mariadb-client \
	&& apt-get clean

RUN mkdir -p /run/php /var/www/html

RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
	&& tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
	&& rm /tmp/wordpress.tar.gz

COPY www.conf /etc/php/8.4/fpm/pool.d/www.conf
COPY ./setup-wordpress.sh /usr/local/bin/setup-wordpress.sh

# make file executable
RUN chmod +x /usr/local/bin/setup-wordpress.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/setup-wordpress.sh"]
