#!/bin/bash

# ONLY IF IS LARAVEL APPLICATION
if [[ "${LARAVEL_APP}" == "1" ]]; then
    # RUN LARAVEL MIGRATIONS ON BUILD.
    if [[ "${RUN_LARAVEL_MIGRATIONS_ON_BUILD}" == "1" ]]; then
        cd ${APP_ROOT}
        php artisan migrate
    fi
fi

# sed -i "s|server_name domain_name;|server_name ${APP_HOST};|" /etc/nginx/sites-available/default.conf
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

sed -i "s|sendfile on|sendfile off|" /etc/nginx/nginx.conf
sed -i "/tty/!s/mesg n/tty -s \\&\\& mesg n/" /root/.profile
sed -i "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|" /etc/php/7.1/cli/php.ini
sed -i "s|;extension=php_pdo_pgsql.dll|extension=php_pdo_pgsql.dll|" /etc/php/7.1/fpm/php.ini
sed -i "s|;extension=php_pgsql.dll|extension=php_pgsql.dll|" /etc/php/7.1/fpm/php.ini

sudo -i -u postgres bash -c "psql -c \"DROP DATABASE IF EXISTS ${DB_DATABASE};\""
sudo -i -u postgres bash -c "psql -c \"CREATE DATABASE ${DB_DATABASE};\""
sudo -i -u postgres bash -c "psql -c \"DROP ROLE IF EXISTS ${DB_USERNAME};\""
sudo -i -u postgres bash -c "psql -c \"CREATE USER ${DB_USERNAME} WITH PASSWORD '${DB_PASSWORD}';\""
sudo -i -u postgres bash -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE ${DB_DATABASE} TO ${DB_USERNAME};\""

sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|" /etc/postgresql/10/main/postgresql.conf
sed -i 's|host    all             all             127.0.0.1/32            md5|host  all all 0.0.0.0/0   md5|' /etc/postgresql/10/main/pg_hba.conf

