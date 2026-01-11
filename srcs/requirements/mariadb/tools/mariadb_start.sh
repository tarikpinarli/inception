#!/bin/bash

# 1. CLEANUP (Critical for restart speed)
rm -f /run/mysqld/mysqld.pid
rm -f /run/mysqld/mysqld.sock

# 2. PERMISSIONS
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# 3. SETUP (Runs only once)
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "MariaDB: Installing..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    /usr/sbin/mysqld --user=mysql --bootstrap --datadir=/var/lib/mysql << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF
    echo "MariaDB: Setup done."
fi

# 4. START (The important change)
# We run the binary DIRECTLY. No wrapper. No mysqld_safe.
echo "MariaDB: Starting direct binary..."
exec /usr/sbin/mysqld --user=mysql --datadir=/var/lib/mysql
