FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl && apt-get clean

# 1. Copy config
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# 2. Copy SSL keys 
COPY ./keys/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
COPY ./keys/nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key

# 3. Copy to not be overwritten by default nginx page
COPY ./keys/index.html /etc/nginx/index.html

# 4. Copy Script and make executable
COPY nginx.sh /usr/local/bin/nginx.sh
RUN chmod +x /usr/local/bin/nginx.sh

EXPOSE 443

HEALTHCHECK CMD service nginx status || exit 1

# 5. Run the script
CMD ["/usr/local/bin/nginx.sh"]
