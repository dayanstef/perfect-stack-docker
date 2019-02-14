# NGINX
FROM ubuntu:bionic

# MAINTAINER.
LABEL maintainer="D. Stefanoski <dejan@newday-media.com>"

# EXPORT & CONFIGURE GLOBALS.
RUN export DEBIAN_FRONTEND=noninteractive \
    LANGUAGE=en_US.UTF-8; \
    LANG=en_US.UTF-8; \
    LC_ALL=en_US.UTF-8;

# INSTALL SOME SYSTEM PACKAGES & SERVICES.
RUN apt-get -yq update && \
    apt-get -yq install software-properties-common \
    tzdata ca-certificates curl gnupg supervisor && \
    add-apt-repository ppa:ondrej/php && \
    locale

# INSTALL APP SERVICES AND EXTENSIONS.
RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh

RUN apt-get -yq install nginx \
    php7.1 \
    php7.1-fpm \
    php7.1-cli \
    php7.1-common \
    php7.1-curl \
    php7.1-intl \
    php7.1-gd \
    php7.1-json \
    php7.1-intl \
    php-pear \
    php-imagick \
    php7.1-imap \
    php7.1-mcrypt \
    memcached \
    php-memcache \
    php7.1-memcached \
    redis \
    php7.1-pspell \
    php7.1-recode \
    php7.1-tidy \
    php7.1-xmlrpc \
    php7.1-xsl \
    php7.1-mbstring \
    php-gettext \
    php7.1-pgsql \
    postgresql \
    postgresql-contrib \
    build-essential \
    composer \
    nodejs

RUN npm install -g laravel-echo-server

ADD start.sh /start.sh
RUN chmod 755 /start.sh
RUN rm -rf /etc/nginx/sites-available/default.conf
ADD config/nginx/default.conf /etc/nginx/sites-available/default.conf

EXPOSE 80 6001 587 25 5432

WORKDIR /var/www

CMD ["/start.sh"]
