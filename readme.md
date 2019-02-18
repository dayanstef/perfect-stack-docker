### Perfect Stack Docker

`php-fpm` `nginx` `postgres` `supervisor` `memcache` `redis` `laravel-echo-server`

##### Default ENV (.env) variables
`PHP_VERSION=7.2`

`POSTGRE_SQL_VERSION=10`

`NODEJS_VERSION=8`

`APP_ROOT=/var/www`

`APP_HOST=localhost`

`APP_PORT=80`

`DB_USERNAME=docker`

`DB_PASSWORD=docker`

`COMPOSER_HASH=544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061`

##### Docker commands for maintaining the Docker build

###### Building
`docker build -t perfect-stack-docker:latest .`

###### Tagging
`docker tag perfect-stack-docker:latest dejanstefano/perfect-stack-docker:latest`

###### Pushing
`docker push dejanstefano/perfect-stack-docker:latest`
