#!/bin/bash

echo 'running redis setup...'

REDIS_DIR=/data/redis
mkdir -p ${REDIS_DIR}
chown -R vagrant:vagrant ${REDIS_DIR}

# for more redis config options, see:
# https://registry.hub.docker.com/_/redis/

docker run -d \
    --name redis \
    --restart=always \
    -v ${REDIS_DIR}:/data \
    -p 6379:6379 \
    -e "SERVICE_TAGS=persistent" \
    redis
