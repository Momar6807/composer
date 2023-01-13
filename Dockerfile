FROM php:8.1-fpm-alpine
RUN echo php -i
RUN apk add --no-cache \
    yarn \
    autoconf \
    g++ \
    make \
    openssl-dev
# Setup bzip2 extension
RUN apk add --no-cache \
    bzip2-dev \
    && docker-php-ext-install -j$(nproc) bz2 \
    && docker-php-ext-enable bz2 \
    && rm -rf /tmp/*
RUN apk add --no-cache coreutils libpng-dev zlib-dev libzip libzip-dev curl-dev
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) zip

# Install intl extension
RUN apk add --no-cache \
    icu-dev \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-enable intl \
    && rm -rf /tmp/*

# Install mbstring extension
RUN apk add --no-cache \
    oniguruma-dev \
    && docker-php-ext-install mbstring \
    && docker-php-ext-enable mbstring \
    && rm -rf /tmp/*

RUN docker-php-ext-enable gd curl
RUN docker-php-ext-enable gd openssl
RUN docker-php-ext-enable gd iconv
RUN docker-php-ext-enable gd mbstring
RUN docker-php-ext-enable gd zip
RUN docker-php-ext-enable gd fileinfo

RUN apk update && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    composer \
    git && \
    rm -rf /var/cache/apk/* && \
    set -xe

COPY composer-entrypoint.sh /usr/local/bin/composer-entrypoint.sh
RUN chmod +x /usr/local/bin/composer-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/composer-entrypoint.sh"]
