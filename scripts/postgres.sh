#!/bin/bash

echo 'running postgre setup...'

POSTGRES_DIR=/data/postgres

mkdir -p ${POSTGRES_DIR}
chown -R vagrant:vagrant ${POSTGRES_DIR}

docker run -d \
    --name postgres \
    -e POSTGRES_PASSWORD='postgres' \
    -p 5432:5432 \
    -v ${POSTGRES_DIR}:/var/lib/postgresql/data \
    --restart=always \
    postgres

# TODO: move this into Vagrant box instead
apt-get -y -q install postgresql-client
