FROM alpine:3.22.1

RUN apk update && apk upgrade

RUN apk add mariadb-client mariadb bash

RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

CMD ["sh", "-c", "mysqld_safe"]