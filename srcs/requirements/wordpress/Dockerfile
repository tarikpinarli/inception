FROM debian:bullseye

# Install PHP and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    mariadb-client \
    php \
    php-cgi \
    php-mysql \
    php-fpm \
    php-pdo \
    php-gd \
    php-cli \
    php-mbstring \
    && rm -rf /var/lib/apt/lists/*

# Create the directory for the PHP socket
RUN mkdir -p /run/php

# Copy the custom configuration
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copy the startup script
COPY ./tools/make_wordpress.sh /usr/local/bin/make_wordpress.sh
RUN chmod +x /usr/local/bin/make_wordpress.sh

# Create the web root (Standardizing on /var/www/html)
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Expose port 9000
EXPOSE 9000

# Start
ENTRYPOINT ["/usr/local/bin/make_wordpress.sh"]
