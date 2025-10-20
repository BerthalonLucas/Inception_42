#!/bin/sh
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM mysql.user WHERE User='';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

echo "Database and users created successfully"

exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0