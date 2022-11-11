#!/usr/bin/env bash
docker_entry_point='/usr/local/bin/docker-entrypoint.sh'
lastline_docker_entrypoint="$(tail -n 1 $docker_entry_point)"

if [[ $lastline_docker_entrypoint == 'exec "$@"' ]]; then
    # remove last line docker-entrypoint.sh (exec can't be called twice)
    sed -i '$d' $docker_entry_point
fi
# call the default docker entrypoint so wordpress is setup
. docker-entrypoint.sh 'apache2'
# add xdebug
pecl install xdebug \
    && docker-php-ext-enable xdebug

exec "$@"