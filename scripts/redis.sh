#!/bin/bash

mkdir -p /data/redis
chown -R vagrant:vagrant /data

# for more redis config options, see:
# https://registry.hub.docker.com/_/redis/

docker run -d \
    --name redis \
    --restart=always \
    -v /data/redis:/data \
    -p 6379:6379 \
    -e "SERVICE_TAGS=persistent" \
    redis
