FROM alpine:3.22.1

RUN apk update  && apk upgrade

RUN apk add openssl nginx curl
# todo add -y to add commands

RUN mkdir certs

RUN openssl req -x509 -nodes -out /certs/inception.crt -keyout /certs/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=lberthal.42.fr/UID=lberthal"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 600 /certs/inception.key \
    && chmod 644 /certs/inception.crt

CMD ["nginx", "-g", "daemon off;"]
