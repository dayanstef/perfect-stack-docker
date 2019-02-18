# OS
FROM ubuntu:bionic

# MAINTAINER.
LABEL maintainer="D. Stefanoski <dejan@newday-media.com>"

# DEFAULT ARGUMENTS
ARG PHP_VERSION=7.2
ARG POSTGRE_SQL_VERSION=10
ARG NODEJS_VERSION=8
ARG APP_ROOT=/var/www
ARG APP_HOST=localhost
ARG APP_PORT=80
ARG DB_USERNAME=docker
ARG DB_PASSWORD=docker
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR ${APP_ROOT}

# EXPORT & CONFIGURE GLOBALS.
RUN DEBIAN_FRONTEND=noninteractive && \
    export LANGUAGE=en_US.UTF-8; \
    LANG=en_US.UTF-8; \
    LC_ALL=en_US.UTF-8;

# INSTALL SOME SYSTEM PACKAGES & SERVICES.
RUN apt-get -yq update && \
    apt-get -yq install software-properties-common \
    tzdata ca-certificates curl wget gnupg git unzip && \
    add-apt-repository ppa:ondrej/php && \
    locale

# INSTALL APP SERVICES AND EXTENSIONS.
RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list'

RUN apt-get update \
    && apt-get -y --no-install-recommends install nginx \
    php${PHP_VERSION} \
    php${PHP_VERSIONs}-fpm \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-intl \
    php-pear \
    php-imagick \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-pspell \
    php${PHP_VERSION}-recode \
    php${PHP_VERSION}-tidy \
    php${PHP_VERSION}-xmlrpc \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xsl \
    php${PHP_VERSION}-mbstring \
    php-gettext \
    php${PHP_VERSION}-pgsql \
    build-essential \
    memcached \
    redis \
    php-memcache \
    php-memcached \
    php${PHP_VERSION}-memcached \
    php-redis \
    php${PHP_VERSION}-zip \
    build-essential \
    software-properties-common \
    postgresql-${POSTGRE_SQL_VERSION} \
    postgresql-client-${POSTGRE_SQL_VERSION} \
    postgresql-contrib-${POSTGRE_SQL_VERSION} \
    supervisor

# CLEANUP THE MESS
RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* && \
    apt-get autoremove && \
    rm -rf ${APP_ROOT}/html && \
    mkdir -p ${APP_ROOT}/logs

COPY nginx/nginx.conf /etc/nginx/site-enabled/default.conf
COPY php-fpm/php-ini-overrides.ini /etc/php/${PHP_VERSION}/fpm/conf.d/99-overrides.ini
COPY supervisor/monitor.conf /etc/supervisor/conf.d/monitor.conf

# OPTIMIZE PHP & NGINX
RUN sed -i 's|sendfile on|sendfile off|' /etc/nginx/nginx.conf && \
    sed -i 's|server_name localhost|server_name ${APP_HOST}|' /etc/nginx/site-enabled/default.conf && \
    sed -i 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|' /etc/php/${PHP_VERSION}/cli/php.ini && \
    sed -i 's|;extension=php_pdo_pgsql.dll|extension=php_pdo_pgsql.dll|' /etc/php/${PHP_VERSION}/fpm/php.ini && \
    sed -i 's|;extension=php_pgsql.dll|extension=php_pgsql.dll|' /etc/php/${PHP_VERSION}/fpm/php.ini

# SETUP DATABASE
USER postgres
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER ${DB_USERNAME} WITH SUPERUSER PASSWORD '${DB_PASSWORD}';" &&\
    createdb -O ${DB_USERNAME} ${DB_PASSWORD}
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/${POSTGRE_SQL_VERSION}/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/${POSTGRE_SQL_VERSION}/main/postgresql.conf

EXPOSE ${APP_PORT}

# PREPARE STARTUP SCRIPT
ADD start.sh /start.sh
ENTRYPOINT ["sh", "/start.sh"]
