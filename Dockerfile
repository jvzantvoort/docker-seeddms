FROM php:7.2-apache
MAINTAINER Ludwig Prager <ludwig.prager@celp.de>

RUN apt-get update && apt-get install -y \
        --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libpng-dev \
        imagemagick \
        poppler-utils \
        catdoc \
        id3 \
        html2text \
        a2ps \
        gnumeric

# unoconv ommitted, creates a 600MiB increase

RUN docker-php-ext-install gd 

RUN php -m | grep -q sqlite \
    || ( \
      apt-get install -y libsqlite3-dev && \
      docker-php-ext-install pdo_sqlite \
    )

ADD misc/seeddms-quickstart-5.1.8.tar.gz /var/www/

RUN a2enmod rewrite

COPY misc/php.ini /usr/local/etc/php/
COPY misc/000-default.conf /etc/apache2/sites-available/

COPY misc/settings.xml /var/www/seeddms51x/conf/settings.xml

RUN chown -R www-data:www-data /var/www/seeddms51x/

RUN touch /var/www/seeddms51x/conf/ENABLE_INSTALL_TOOL
