#!/bin/bash

# UPDATE THE WEBROOT IF REQUIRED.
if [[ ! -z "${APP_ROOT}" ]] && [[ ! -z "${APP_ROOT_PUBLIC}" ]]; then
    sed -i "s|root /var/www/public;|root ${APP_ROOT_PUBLIC};|" /etc/nginx/sites-available/default.conf
else
    export APP_ROOT=/var/www
    export APP_ROOT_PUBLIC=/var/www/public
fi

# ONLY IF IS LARAVEL APPLICATION
if [[ "${LARAVEL_APP}" == "1" ]]; then
    # RUN LARAVEL MIGRATIONS ON BUILD.
    if [[ "${RUN_LARAVEL_MIGRATIONS_ON_BUILD}" == "1" ]]; then
        cd ${APP_ROOT}
        php artisan migrate
    fi
fi

sed -i "s|server_name domain_name;|server_name ${APP_HOST};|" /etc/nginx/sites-available/default.conf
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

sed -i "s|sendfile on|sendfile off|" /etc/nginx/nginx.conf
sed -i "/tty/!s/mesg n/tty -s \\&\\& mesg n/" /root/.profile
sed -i "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|" /etc/php/7.1/cli/php.ini
sed -i "s|;extension=php_pdo_pgsql.dll|extension=php_pdo_pgsql.dll|" /etc/php/7.1/fpm/php.ini
sed -i "s|;extension=php_pgsql.dll|extension=php_pgsql.dll|" /etc/php/7.1/fpm/php.ini

