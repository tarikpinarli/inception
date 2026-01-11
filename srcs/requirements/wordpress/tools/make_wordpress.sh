#!/bin/bash

# 1. Download WP-CLI (if missing)
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# 2. Go to the correct web folder
cd /var/www/html

# 3. Check if WordPress is already installed
if [ ! -f wp-config.php ]; then
    echo "WordPress: Setting up..."

    # Download WordPress
    wp core download --allow-root

    # Wait for MariaDB to be ready
    echo "WordPress: Waiting for MariaDB to be ready..."
    while ! mariadb -h mariadb -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1;" >/dev/null 2>&1; do
        echo "Waiting for MariaDB..."
        sleep 3
    done
    echo "MariaDB is ready!"

    # Create config
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    # Install WordPress
    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    # Create the second user
    wp user create \
        $WP_USER \
        $WP_USER_EMAIL \
        --role=author \
        --user_pass=$WP_USER_PASSWORD \
        --allow-root
        
    echo "WordPress: Configuration finished!"
fi

# --- CRITICAL FIX: Give permission to web server ---
# Without this, NGINX cannot read the files and will give 403 Forbidden
chown -R www-data:www-data /var/www/html
# -------------------------------------------------

# 4. Start PHP-FPM
echo "WordPress: Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
