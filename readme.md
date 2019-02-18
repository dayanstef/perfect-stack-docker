### Perfect Stack Docker

`php-fpm` `nginx` `postgres` `supervisor` `memcache` `redis` `laravel-echo-server`

##### Docker commands for maintaining the Docker build

###### Building
`docker build -t perfect-stack-docker:latest .`

###### Tagging
`docker tag perfect-stack-docker:latest dejanstefano/perfect-stack-docker:latest`

###### Pushing
`docker push dejanstefano/perfect-stack-docker:latest`
