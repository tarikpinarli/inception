FROM debian:bullseye

# Install MariaDB Server
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Ensure the directory for the socket exists and has correct permissions
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# Copy the configuration file
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the startup script
COPY tools/mariadb_start.sh /usr/local/bin/mariadb_start.sh
RUN chmod +x /usr/local/bin/mariadb_start.sh

# Expose the standard MySQL port
EXPOSE 3306

# Start
ENTRYPOINT ["/usr/local/bin/mariadb_start.sh"]
