FROM php:8.1-fpm-alpine
RUN apk add --no-cache coreutils libpng-dev zlib-dev libzip libzip-dev

RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) zip

RUN apk update && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    composer \
    git && \
    rm -rf /var/cache/apk/* && \
    set -xe && \
    composer clear-cache

COPY composer-entrypoint /usr/local/bin/composer-entrypoint.sh
RUN chmod +x /usr/local/bin/composer-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/composer-entrypoint.sh"]
