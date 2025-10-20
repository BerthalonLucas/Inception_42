#!/bin/sh


echo "Waiting for Mariadb..."
until mariadb -h maria-db -u ${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} -e "SELECT 1" &>/dev/null; do
    sleep 2
done
echo "Mariadb ready!"

cd /var/www/html/wordpress

echo "testing install wp cli install"

# if [wp --infos &>/dev/null]; then
#     echo "wp cli installed"
# else
#     echo "wp cli not installed"
#     exit 1
# fi

wp config create \
    --dbname=${WORDPRESS_DB_NAME} \
    --dbuser=${WORDPRESS_DB_USER} \
    --dbpass=${WORDPRESS_DB_PASSWORD} \
    --dbhost=${WORDPRESS_DB_HOST} \
    --allow-root

wp core install \
    --url=${WP_URL} \
    --title="${WP_TITLE}" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --skip-email \
    --allow-root

wp user create ${WP_USER} ${WP_USER_EMAIL} \
    --role=author \
    --user_pass=${WP_USER_PASSWORD} \
    --allow-root

echo "WordPress installation complete!"

exec /usr/sbin/php-fpm* -F