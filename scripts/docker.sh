#!/bin/bash

set -e

IP=`ifconfig eth1 | grep 'inet addr' | sed 's/.*addr:\([0-9.]*\) .*/\1/'`

# generated using
# docker run --rm progrium/consul cmd:run ${IP} -d

docker run \
    --name consul \
    --restart=always \
    -h $HOSTNAME \
    -p ${IP}:8300:8300 \
    -p ${IP}:8301:8301 \
    -p ${IP}:8301:8301/udp \
    -p ${IP}:8302:8302 \
    -p ${IP}:8302:8302/udp \
    -p ${IP}:8400:8400 \
    -p ${IP}:8500:8500 \
    -p ${IP}:53:53/udp \
    -d progrium/consul \
    -server \
    -advertise ${IP} \
    -bootstrap

docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -h $HOSTNAME \
    --restart=always \
    --name registrator \
    progrium/registrator consul://${IP}:8500

mkdir -p /data/redis
chown -R vagrant:vagrant /data

# for more config options, see:
# https://registry.hub.docker.com/_/redis/
#
docker run -d \
    --name redis \
    --restart=always \
    -h $HOSTNAME \
    -v /data/redis:/data \
    -p 6379:6379 \
    -e "SERVICE_TAGS=persistent" \
    redis
