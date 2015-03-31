#!/bin/bash

echo 'running errbit setup...'

MONGO_DIR=/data/mongo

mkdir -p ${MONGO_DIR}
chown -R vagrant:vagrant ${MONGO_DIR}

docker run -d \
    --name mongodb \
    --restart=always \
    -v ${MONGO_DIR}:/data/db \
    -p 27017:27017 \
    mongo

# TODO: change this to pull the service info from consul, as it has to run on the same host using the below setup
docker run --rm --link mongodb:mongodb griff/errbit seed
docker run -d --name errbit --link mongodb:mongodb -p 3000:3000 griff/errbit
