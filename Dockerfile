FROM php:7.4-fpm-alpine
RUN apk add --no-cache coreutils libpng-dev zlib-dev libzip libzip-dev

COPY ./php.ini /etc/php/7.4/apache2/php.ini

RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-install -j$(nproc) intl

RUN apk update && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    composer \
    git && \
    rm -rf /var/cache/apk/* && \
    set -xe && \
        composer global require hirak/prestissimo && \
        composer clear-cache


COPY composer-entrypoint /usr/local/bin/composer-entrypoint
RUN chmod +x /usr/local/bin/composer-entrypoint

ENTRYPOINT ["/usr/local/bin/composer-entrypoint"]
