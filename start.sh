#!/bin/bash

# ONLY IF IS LARAVEL APPLICATION
if [[ "${LARAVEL_APP}" == "1" ]]; then
    # RUN LARAVEL MIGRATIONS ON BUILD.
    if [[ "${RUN_LARAVEL_MIGRATIONS_ON_BUILD}" == "1" ]]; then
        cd ${APP_ROOT}
        php artisan migrate
    fi
fi

sed -i "s|sendfile on|sendfile off|" /etc/nginx/nginx.conf
sed -i "/tty/!s/mesg n/tty -s \\&\\& mesg n/" /root/.profile
sed -i "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|" /etc/php/7.2/cli/php.ini
sed -i "s|;extension=php_pdo_pgsql.dll|extension=php_pdo_pgsql.dll|" /etc/php/7.2/fpm/php.ini
sed -i "s|;extension=php_pgsql.dll|extension=php_pgsql.dll|" /etc/php/7.2/fpm/php.ini

systemctl restart php7.2-fpm.service
systemctl restart nginx.service
