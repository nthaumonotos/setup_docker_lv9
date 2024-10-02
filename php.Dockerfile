# Stage 1: Build
FROM docker.io/php:8.0-fpm AS build
COPY --from=composer:2.7.7 /usr/bin/composer /usr/bin/composer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod 0755 /usr/local/bin/install-php-extensions
RUN install-php-extensions gd opcache zip fileinfo curl pdo pdo_mysql
RUN docker-php-ext-enable gd opcache zip
# RUN apt-get update
# RUN apt-get install -y git
# RUN composer install

ARG U_ID=1000
ARG G_ID=1000
RUN deluser www-data 2>/dev/null || true
RUN addgroup --gid ${G_ID} www-data \
    && useradd --uid ${U_ID} --gid www-data -d /var/www-data -s /usr/sbin/nologin -M www-data
USER www-data
EXPOSE 9000
CMD ["php-fpm"]