FROM php:8.1-fpm-alpine
RUN apk add --no-cache coreutils libpng-dev zlib-dev libzip libzip-dev libcurl

RUN php --ini

RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-install -j$(nproc) curl
RUN docker-php-ext-install -j$(nproc) iconv
RUN docker-php-ext-install -j$(nproc) mbstring
RUN docker-php-ext-install -j$(nproc) openssl
RUN docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-install -j$(nproc) phar

RUN apk update && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    composer \
    git && \
    rm -rf /var/cache/apk/* && \
    set -xe

COPY composer-entrypoint.sh /usr/local/bin/composer-entrypoint.sh
RUN chmod +x /usr/local/bin/composer-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/composer-entrypoint.sh"]
