FROM alpine:3.22.1

RUN apk update && apk upgrade && \
    apk add php php-fpm php-mysqli php-json php-curl php-dom php-exif \
            php-fileinfo php-mbstring php-openssl php-xml php-zip \
            wget curl mariadb-client

RUN mkdir -p /var/www/html && wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress /var/www/html && \
    rm latest.tar.gz

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh


RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php*/php-fpm.d/www.conf

CMD ["/setup.sh"]