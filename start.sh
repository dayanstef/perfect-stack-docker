#!/bin/bash

sed -i "s|sendfile on|sendfile off|" /etc/nginx/nginx.conf
sed -i "s|;extension=php_pdo_pgsql.dll|extension=php_pdo_pgsql.dll|" /etc/php/7.2/fpm/php.ini
sed -i "s|;extension=php_pgsql.dll|extension=php_pgsql.dll|" /etc/php/7.2/fpm/php.ini

# ONLY IF IS LARAVEL APPLICATION
if [[ "${LARAVEL_APP}" == "1" ]]; then
    # RUN LARAVEL MIGRATIONS ON BUILD.
    if [[ "${RUN_LARAVEL_MIGRATIONS_ON_BUILD}" == "1" ]]; then
        cd ${APP_ROOT}
        php artisan migrate
    fi
fi
