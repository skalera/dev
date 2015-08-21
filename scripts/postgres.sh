#!/bin/bash

. /vagrant/config/consul.env

echo 'running postgres setup...'

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

sleep 3

IP=`ifconfig eth1 | grep 'inet addr' | sed 's/.*addr:\([0-9.]*\) .*/\1/'`

USER='skalera'
PASSWORD=`dd bs=8 count=1 if=/dev/random 2> /dev/null | od -x | head -1 | sed -e 's/000000 //' -e 's/ //g'`

curl -s -d "${USER}" -X PUT http://${IP}:8500/v1/kv/postgres/user?token=${CONSUL_KV_KEY}
curl -s -d "${PASSWORD}" -X PUT http://${IP}:8500/v1/kv/postgres/password?token=${CONSUL_KV_KEY}

export PGUSER=postgres
export PGPASSWORD=postgres
export PGHOST=${IP}

psql -c "create role skalera unencrypted password '${PASSWORD}' login"

createdb -O ${USER} -U postgres -h ${IP} clockwork
createdb -O ${USER} -U postgres -h ${IP} skalera
