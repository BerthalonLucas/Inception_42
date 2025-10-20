FROM alpine:3.22.1

RUN apk update && apk upgrade

RUN apk add mariadb mariadb-client

RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

COPY ./tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

COPY ./conf/my.cnf /etc/my.cnf.d/zzz-custom.cnf

CMD ["sh", "-c", "/entrypoint.sh"]