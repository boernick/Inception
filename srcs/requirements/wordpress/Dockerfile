FROM debian:stable

RUN apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	curl \
	sudo \
	&& apt-get clean

RUN mkdir -p /run/php /var/www/html

# Manually download WordPress and run it with PHP-FPM only
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
	&& tar -xzf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
	&& rm /tmp/wordpress.tar.gz

COPY www.conf /etc/php/8.4/fpm/pool.d/www.conf
COPY wp-config.php /var/www/html/wp-config.php
COPY setup-wordpress.sh /etc/php/setup=wordpress.sh

CMD ["/usr/local/bin/setup-wordpress.sh"]
