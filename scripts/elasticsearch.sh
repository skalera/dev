#!/bin/bash

echo 'running elasticsearch setup...'

DATA_DIR=/data/elasticsearch
mkdir -p ${DATA_DIR}
# cp /vagrant/config/elasticsearch.yml ${DATA_DIR}/elasticsearch.yml
chown -R vagrant:vagrant ${DATA_DIR}

docker run -d \
  --name elasticsearch \
  --restart=always \
  -v ${DATA_DIR}:/data \
  -p 9200:9200 \
  -p 9300:9300 \
  -e "SERVICE_TAGS=persistent" \
  elasticsearch

