#!/bin/bash

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "Nginx: Setting up SSL..."
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=FI/ST=Helsinki/L=Helsinki/O=42/OU=42/CN=tpinarli.42.fr/UID=tpinarli"
fi

echo "Nginx: Starting..."
exec nginx -g "daemon off;"
