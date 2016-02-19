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

# TODO: instead loop a few times for a max of 10 seconds
sleep 5

IP=`ifconfig eth1 | grep 'inet addr' | sed 's/.*addr:\([0-9.]*\) .*/\1/'`

USER='skalera'
PASSWORD=`uuid`

curl -s -d "${USER}" -X PUT http://${IP}:8500/v1/kv/postgres/user?token=${CONSUL_ACL_TOKEN}
curl -s -d "${PASSWORD}" -X PUT http://${IP}:8500/v1/kv/postgres/password?token=${CONSUL_ACL_TOKEN}

export PGUSER=postgres
export PGPASSWORD=postgres
export PGHOST=${IP}

# make sure we can connect, if not wait a little longer
psql -c "select version();" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    sleep 5
fi

psql -c "create role skalera unencrypted password '${PASSWORD}' login"

createdb -O ${USER} -U postgres -h ${IP} clockwork
createdb -O ${USER} -U postgres -h ${IP} skalera
createdb -O ${USER} -U postgres -h ${IP} thresholds
createdb -O ${USER} -U postgres -h ${IP} mvp-ui
