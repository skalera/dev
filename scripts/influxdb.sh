#!/bin/bash

echo 'running influxdb setup...'

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
    skalera/influxdb
