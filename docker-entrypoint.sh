#!/bin/bash
set -e

# Render passes the port in $PORT (default 10000)
PORT="${PORT:-80}"
echo "Configuring Apache to listen on port ${PORT}..."
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf

# Database handling:
if [ -n "$DB_SERVER" ] && [ "$DB_SERVER" != "localhost" ] && [ "$DB_SERVER" != "127.0.0.1" ]; then
    echo "Using external MySQL server at $DB_SERVER"
else
    echo "Setting up local MariaDB directories..."
    mkdir -p /var/run/mysqld
    chown -R mysql:mysql /var/run/mysqld
    chmod 777 /var/run/mysqld

    if [ ! -d "/var/lib/mysql/mysql" ]; then
        echo "Initializing MariaDB data directory..."
        mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1 || true
    fi

    echo "Starting local MariaDB service..."
    service mariadb start || /usr/bin/mysqld_safe --datadir='/var/lib/mysql' &

    echo "Waiting for MariaDB to become ready..."
    for i in {1..30}; do
        if mysqladmin ping --silent 2>/dev/null; then
            echo "MariaDB is up and running!"
            break
        fi
        sleep 1
    done

    # Symlink socket so localhost works everywhere
    ln -sf /var/run/mysqld/mysqld.sock /tmp/mysql.sock 2>/dev/null || true

    echo "Configuring local database permissions..."
    mysql -e "CREATE DATABASE IF NOT EXISTS ptms_db;" 2>/dev/null || true
    mysql -e "CREATE USER IF NOT EXISTS 'ptms_user'@'%' IDENTIFIED BY 'ptms_pass123';" 2>/dev/null || true
    mysql -e "ALTER USER 'ptms_user'@'%' IDENTIFIED BY 'ptms_pass123';" 2>/dev/null || true
    mysql -e "GRANT ALL PRIVILEGES ON ptms_db.* TO 'ptms_user'@'%'; FLUSH PRIVILEGES;" 2>/dev/null || true

    # Check if database has tables
    TABLE_COUNT=$(mysql -N -s -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'ptms_db';" 2>/dev/null || echo 0)
    if [ "$TABLE_COUNT" -eq 0 ]; then
        echo "Importing ptms_db.sql into ptms_db..."
        if [ -f /var/www/html/database/ptms_db.sql ]; then
            mysql ptms_db < /var/www/html/database/ptms_db.sql
            echo "Database import completed successfully!"
        fi
    else
        echo "Database already has $TABLE_COUNT tables. Skipping import."
    fi
fi

# Ensure uploads directory is writable
chmod -R 777 /var/www/html/uploads 2>/dev/null || true

echo "Starting Apache Web Server on port ${PORT}..."
exec apache2-foreground
