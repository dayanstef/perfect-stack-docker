#!/bin/bash

cd ${APP_ROOT}

# ONLY IF IS LARAVEL APPLICATION
if [[ "${LARAVEL_APP}" == "1" ]]; then
    make install-backend
    make install-frontend
    make npm-run-prod

    # RUN LARAVEL MIGRATIONS ON BUILD.
    if [[ "${RUN_LARAVEL_MIGRATIONS_ON_BUILD}" == "1" ]]; then
        php artisan migrate
    fi
fi
