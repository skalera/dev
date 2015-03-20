#!/bin/bash

POSTGRES_DIR=/data/postgres

mkdir -p ${POSTGRES_DIR}
chown -R vagrant:vagrant ${POSTGRES_DIR}

docker run -d \
    --name postgres \
    -e POSTGRES_PASSWORD='postgres' \
    -p 5432:5432 \
    -v ${POSTGRES_DIR}:/var/lib/postgresql/data \
    postgres

# TODO: move this into Vagrant box instead
apt-get install postgresql-client
