chown -R www-data:www-data /var/log/nginx/nginx
chown -R www-data:www-data /var/www/html
mkdir -p /var/www/html/static/
cp /etc/nginx/index.html /var/www/html/static/index.html
cp /run/secrets/ssl_private_key /etc/ssl/private/nginx-selfsigned.key
nginx -g "daemon off;"
