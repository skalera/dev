#!/bin/bash

. /vagrant/config/consul.env

echo 'running influxdb setup...'
echo ${CONSUL_ACL_TOKEN}

INFLUX_DIR=/data/influxdb
mkdir -p ${INFLUX_DIR}
cp /vagrant/config/influx.conf /data/influxdb/influx.conf
chown -R vagrant:vagrant ${INFLUX_DIR}

docker run -d \
    --name influxdb \
    --restart=always \
    -v ${INFLUX_DIR}:/data \
    -p 8083:8083 \
    -p 8086:8086 \
    -p 127.0.0.1:8088:8088 \
    skalera/influxdb

# TODO: instead loop a few times for a max of 10 seconds
sleep 3

IP=`ifconfig eth1 | grep 'inet addr' | sed 's/.*addr:\([0-9.]*\) .*/\1/'`

USER='skalera'
PASSWORD=`uuid`

curl -s -d "${USER}" -X PUT http://${IP}:8500/v1/kv/influxdb/user?token=${CONSUL_ACL_TOKEN}
curl -s -d "${PASSWORD}" -X PUT http://${IP}:8500/v1/kv/influxdb/password?token=${CONSUL_ACL_TOKEN}

INFLUX="influx -host ${IP} -username root -password root"
# TODO: change root's password

echo 'create database metrics' | ${INFLUX} -database root
echo "create user ${USER} with password '{$PASSWORD}'" | ${INFLUX}
echo "grant all on metrics to ${USER}" | ${INFLUX}
