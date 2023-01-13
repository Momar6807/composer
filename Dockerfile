FROM php:8.1-fpm-alpine
RUN php --ini
# Install Additional dependencies
RUN apk update && apk add --no-cache \
    build-base shadow vim curl zlib libzip-dev \
    libpng-dev libjpeg-turbo-dev libwebp-dev libxpm-dev zlib-dev \
    openssl-dev oniguruma-dev \
    icu-dev bzip2-dev freetype freetype-dev \
    php7 \
    php7-cli \
    php7-redis \
    php7-gd \
    php7-common \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqli \
    php7-curl \
    php7-mcrypt \
    php7-intl \
    php7-json \
    php7-xdebug \
    php7-mbstring \
    php7-redis \
    php7-pear \
    php7-xml \
    php7-phar \
    php7-zip

RUN set -xe && \
    cd /tmp/ && \
    apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS

# Add and Enable PHP-PDO Extenstions
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN docker-php-ext-install mbstring

RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/
RUN docker-php-ext-install gd
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install bz2
RUN pecl install igbinary
RUN pecl install redis
RUN docker-php-ext-enable pdo_mysql igbinary mbstring redis gd zip intl bz2



RUN apk update && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    composer \
    git && \
    rm -rf /var/cache/apk/* && \
    set -xe

COPY composer-entrypoint.sh /usr/local/bin/composer-entrypoint.sh
RUN chmod +x /usr/local/bin/composer-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/composer-entrypoint.sh"]
