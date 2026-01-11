FROM debian:bullseye

# Install NGINX and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Copy the NGINX configuration
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# Copy the startup script
COPY tools/nginx_start.sh /var/www/nginx_start.sh

# Give execution rights to the script
RUN chmod +x /var/www/nginx_start.sh

# Expose the only allowed port
EXPOSE 443

# Start NGINX using the script
ENTRYPOINT ["/var/www/nginx_start.sh"]
