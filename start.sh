#!/bin/bash

# ONLY IF IS LARAVEL APPLICATION
if [[ "${LARAVEL_APP}" == "1" ]]; then
    # RUN LARAVEL MIGRATIONS ON BUILD.
    if [[ "${RUN_LARAVEL_MIGRATIONS_ON_BUILD}" == "1" ]]; then
        cd ${APP_ROOT}
        php artisan migrate
    fi
fi
