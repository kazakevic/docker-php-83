# Base image
FROM php:8.3-fpm-alpine

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install packages
RUN apk add --no-cache curl bash vim build-base zlib-dev oniguruma-dev autoconf bash supervisor
RUN apk add --update linux-headers

RUN mkdir -p /etc/supervisor/conf.d

# Configure non-root user.
ARG PUID=1000
ARG PGID=1000
RUN apk --no-cache add shadow && \
    groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd xdebug amqp xml intl pdo_mysql pdo_pgsql @composer-2

# Switch to www-data user
USER www-data

CMD ["php-fpm"]
