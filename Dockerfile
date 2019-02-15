# NGINX
FROM ubuntu:bionic

# MAINTAINER.
LABEL maintainer="D. Stefanoski <dejan@newday-media.com>"

# EXPORT & CONFIGURE GLOBALS.
RUN DEBIAN_FRONTEND=noninteractive && \
    export LANGUAGE=en_US.UTF-8; \
    LANG=en_US.UTF-8; \
    LC_ALL=en_US.UTF-8;

# INSTALL SOME SYSTEM PACKAGES & SERVICES.
RUN apt-get -yq update && \
    apt-get -yq install software-properties-common \
    tzdata ca-certificates curl wget gnupg && \
    add-apt-repository ppa:ondrej/php && \
    locale

# INSTALL APP SERVICES AND EXTENSIONS.
RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh

RUN apt-get -yq install nginx \
    php7.2 \
    php7.2-fpm \
    php7.2-cli \
    php7.2-common \
    php7.2-curl \
    php7.2-intl \
    php7.2-gd \
    php7.2-json \
    php7.2-intl \
    php-pear \
    php-imagick \
    php7.2-imap \
    php7.2-pspell \
    php7.2-recode \
    php7.2-tidy \
    php7.2-xmlrpc \
    php7.2-xml \
    php7.2-xsl \
    php7.2-mbstring \
    php-gettext \
    php7.2-pgsql \
    build-essential \
    php7.2-zip \
    composer \
    nodejs

RUN npm install -g laravel-echo-server

COPY start.sh /start.sh
RUN chmod 755 /start.sh
RUN rm -rf /etc/nginx/sites-enabled/*
COPY config/nginx/default.conf /etc/nginx/sites-enabled/default.conf

# NGINX PORT
EXPOSE 80

# LARAVEL ECHO SERVER PORT
EXPOSE 6001

# WORKIN DIRECTORY
WORKDIR /var/www

# INIT SCRIPT
CMD ["/start.sh"]
