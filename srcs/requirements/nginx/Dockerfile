FROM debian:stable

RUN apt-get update && apt-get install -y nginx openssl && apt-get clean

COPY ./nginx.conf /etc/nginx/conf.d/nginx.conf
# COPY requirements/nginx/keys/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
# COPY requirements/nginx/nginx.sh /etc/nginx/nginx.sh
# COPY requirements/nginx/index.html /etc/nginx/index.html

CMD ["nginx", "-g", "daemon off;"]
