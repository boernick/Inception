FROM debian:stable

RUN apt-get update && apt-get install -y nginx openssl && apt-get clean

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY ./keys/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
COPY ./keys/nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key
COPY ./keys/index.html /var/www/html/index.html
# COPY nginx.sh /etc/nginx/nginx.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
