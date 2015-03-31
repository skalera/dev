#!/bin/bash

echo 'running influxdb setup...'

INFLUX_DIR=/data/influxdb
mkdir -p ${INFLUX_DIR}/log ${INFLUX_DIR}/raft ${INFLUX_DIR}/db
cp /vagrant/config/influxdb.toml /data/influxdb/config.toml
chown -R vagrant:vagrant ${INFLUX_DIR}

docker run -d \
    --name influxdb \
    --restart=always \
    -v ${INFLUX_DIR}:/data \
    -p 8083:8083 \
    -p 8086:8086 \
    skalera/influxdb
