FROM alpine:3.22.1

RUN apk update  && apk upgrade

RUN apk add mariadb mariadb-client

RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

CMD ["sh", "-c", "mariadb start && sleep 1000"]