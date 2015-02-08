#!/bin/bash

mkdir -p /data/influxdb/log
cp /vagrant/config/influxdb.toml /data/influxdb/config.toml
chown -R vagrant:vagrant /data

docker run -d \
    --name influxbd \
    --restart=always \
    -v /data/influxdb:/data \
    -p 8083:8083 \
    -p 8086:8086 \
    skalera/influxdb
