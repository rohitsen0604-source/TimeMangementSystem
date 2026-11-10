#!/bin/bash
set -e

# Render passes the port in $PORT (default 10000)
PORT="${PORT:-80}"
echo "Configuring Apache to listen on port ${PORT}..."
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf

# Database handling:
# If external DB_SERVER is provided (and not localhost/127.0.0.1), use it.
if [ -n "$DB_SERVER" ] && [ "$DB_SERVER" != "localhost" ] && [ "$DB_SERVER" != "127.0.0.1" ]; then
    echo "Using external MySQL server at $DB_SERVER"
else
    echo "Starting local MariaDB service..."
    service mariadb start

    echo "Configuring local database..."
    mysql -e "CREATE DATABASE IF NOT EXISTS ptms_db;"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD(''); FLUSH PRIVILEGES;" 2>/dev/null || true

    # Check if database has tables
    TABLE_COUNT=$(mysql -N -s -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'ptms_db';" 2>/dev/null || echo 0)
    if [ "$TABLE_COUNT" -eq 0 ]; then
        echo "Importing ptms_db.sql..."
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

