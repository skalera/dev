#!/bin/bash

echo 'running docker setup...'

set -e

IP=`ifconfig eth1 | grep 'inet addr' | sed 's/.*addr:\([0-9.]*\) .*/\1/'`

# make sure all containers can do DNS lookups through consul
echo "DOCKER_OPTS='--dns ${IP} --dns 8.8.8.8 --dns-search service.consul'" > /etc/default/docker
service docker restart
# HACK: wait a little while docker starts
sleep 3

# generated using
# docker run --rm progrium/consul cmd:run ${IP} -d

docker run \
    --name consul \
    --restart=always \
    -h ${HOSTNAME} \
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
    -v /var/run/docker.sock:/tmp/docker.sock \
    -h ${HOSTNAME} \
    --restart=always \
    --name registrator \
    gliderlabs/registrator consul://${IP}:8500
