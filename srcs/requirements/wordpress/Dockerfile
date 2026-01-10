FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysqli \
    mariadb-client \
    curl \
    sudo \
    && apt-get clean

# Install WP-CLI globally
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Create necessary directories
RUN mkdir -p /run/php /var/www/html && \
    chown -R www-data:www-data /run/php /var/www/html

# Copy configuration files
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY ./setup-wordpress.sh /usr/local/bin/setup-wordpress.sh

RUN chmod +x /usr/local/bin/setup-wordpress.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/setup-wordpress.sh"]
