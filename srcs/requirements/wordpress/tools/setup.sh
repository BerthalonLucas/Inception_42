#!/bin/sh

echo "=========================================="
echo "WORDPRESS SETUP STARTING"
echo "=========================================="

WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# Télécharge WordPress si pas déjà présent
if [ ! -f "/var/www/html/wordpress/wp-config-sample.php" ]; then
    echo "WordPress not found. Downloading..."
    cd /var/www/html
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    rm latest.tar.gz
    echo "✅ WordPress downloaded and extracted"
else
    echo "✅ WordPress already present"
fi

echo "Waiting for mariadb..."
sleep 10
until mariadb -h maria-db -u ${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} -e "SELECT 1" &>/dev/null; do
    echo "mariadb not ready yet... retrying in 3s"
    sleep 3
done
echo "mariadb ready!"

cd /var/www/html/wordpress

# Créer wp-config.php si nécessaire
if [ ! -f "wp-config.php" ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --allow-root
    echo "✅ wp-config.php created"
fi

# Vérifie si les tables WordPress existent
echo "Checking if WordPress tables exist..."
TABLE_COUNT=$(mariadb -h maria-db -u ${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} ${WORDPRESS_DB_NAME} -sse "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '${WORDPRESS_DB_NAME}';")

echo "Found $TABLE_COUNT tables in database"

if [ "$TABLE_COUNT" -eq "0" ]; then
    echo "No WordPress tables found. Installing WordPress..."
    
    wp core install \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email \
        --allow-root
    
    echo "Creating regular user..."
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD} \
        --allow-root
    
    echo "✅ WordPress installation complete!"
else
    echo "✅ WordPress already installed ($TABLE_COUNT tables found)"
fi

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm* -F