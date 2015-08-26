#!/bin/bash

echo 'running docker setup...'

set -e

function create_consul_config {
  echo "creating consul config..."
  CONSUL_DIR=/data/consul
  mkdir -p ${CONSUL_DIR}
  export CONSUL_MASTER_KEY=`uuid`
  # export CONSUL_MASTER_KEY=f45cbd0b-5022-47ab-8640-4eaa7c1f40f1 #TEST 
  envsubst < /vagrant/config/templates/consul_config_template.json > /data/consul/consul.json
}
function update_anon_acl {
  echo "updating anonymous acl..."
  curl -f -s -d @/vagrant/config/templates/anon_acl.json \
    -X PUT http://${IP}:8500/v1/acl/update?token=${CONSUL_MASTER_KEY} > /dev/null
  if [ $? -ne 0 ]; then
    echo "Err: Failed to update Anonymous ACL..."
    exit 1
  fi
}
function create_kv_acl {
  echo "adding K/V Store ACL..."
  export CONSUL_KV_KEY=`curl -f -s -d @/vagrant/config/templates/kv_acl.json \
    -X PUT http://${IP}:8500/v1/acl/create?token=${CONSUL_MASTER_KEY}| \
    awk -F: '{print $2}'|sed 's/"//g'|tr -d '{}'`
  if [ -z "$CONSUL_KV_KEY" ]; then
    echo "ERR: Failed to add K/V ACL.."
    exit 1
  fi
  # echo $CONSUL_KV_KEY
}
function update_kv_acl {
  echo "updating K/V Store ACL..."
  envsubst < /vagrant/config/templates/kv_acl_rules.json > /tmp/kv_acl_rules.json
  curl -f -s -d @/tmp/kv_acl_rules.json \
    -X PUT http://${IP}:8500/v1/acl/update?token=${CONSUL_MASTER_KEY} > /dev/null
  if [ $? -ne 0 ]; then
    echo "Err: Failed to update rules for K/V ACL..."
    exit 1
  fi
}
function clean_up {
  echo "cleaning up..."
  rm /tmp/kv_acl_rules.json
}
function report {
  echo "***************** Report *****************"
  echo "Please use this token to connect to consul"
  echo $CONSUL_KV_KEY
  echo "export CONSUL_KV_KEY=$CONSUL_KV_KEY" > /vagrant/config/consul.env
}

IP=`ifconfig eth1 | grep 'inet addr' | sed 's/.*addr:\([0-9.]*\) .*/\1/'`

# make sure all containers can do DNS lookups through consul
echo "DOCKER_OPTS='--dns ${IP} --dns 8.8.8.8 --dns-search service.consul'" > /etc/default/docker
service docker restart
# HACK: wait a little while docker starts
sleep 3

# generated using
# docker run --rm progrium/consul cmd:run ${IP} -d
create_consul_config

docker run \
 --name consul \
 --restart=always \
 -v /data/consul/consul.json:/config/consul.json \
 -h ${HOSTNAME} \
 -p ${IP}:8300:8300 \
 -p ${IP}:8301:8301 \
 -p ${IP}:8301:8301/udp \
 -p ${IP}:8302:8302 \
 -p ${IP}:8302:8302/udp \
 -p ${IP}:8400:8400 \
 -p ${IP}:8500:8500 \
 -p ${IP}:53:53/udp \
 -d  progrium/consul \
 -server \
 -advertise ${IP} \
 -bootstrap
# wait a bit...
sleep 3

update_anon_acl
create_kv_acl
update_kv_acl
clean_up
report


docker run -d \
    -v /var/run/docker.sock:/tmp/docker.sock \
    -h ${HOSTNAME} \
    --restart=always \
    --name registrator \
    gliderlabs/registrator consul://${IP}:8500
