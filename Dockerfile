FROM php:8.1-fpm-alpine
RUN php --ini
RUN apk add --no-cache coreutils libpng-dev zlib-dev libzip libzip-dev curl
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) zip

RUN apk add gnu-libiconv=1.15-r3 openssl php-phar oniguruma-dev


RUN apk update && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    composer \
    git && \
    rm -rf /var/cache/apk/* && \
    set -xe

COPY composer-entrypoint.sh /usr/local/bin/composer-entrypoint.sh
RUN chmod +x /usr/local/bin/composer-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/composer-entrypoint.sh"]
