#!/bin/sh -e

echo 'running docker setup...'

# Add the repository to your APT sources
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

# Then import the repository key
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Install docker
apt-get -qq update
apt-get -qq install -y lxc-docker

usermod --groups docker vagrant

# pull in images we're going to use later

docker pull progrium/consul
docker pull gliderlabs/registrator
docker pull redis
docker pull nginx
docker pull postgres
docker pull skalera/influxdb
docker pull mongo
docker pull griff/errbit
docker pull library/elasticsearch
docker pull skalera/logspout # TODO: hook this up correctly
docker pull skalera/clockwork

# add influx and envconsul command to VM image
wget -O /usr/bin/influx https://s3-us-west-2.amazonaws.com/skalera/vagrant/influx-0.9.6.1
wget -O /usr/bin/influxd https://s3-us-west-2.amazonaws.com/skalera/vagrant/influxd-0.9.6.1
wget -O /usr/bin/envconsul https://s3-us-west-2.amazonaws.com/skalera/vagrant/envconsul
chmod 755 /usr/bin/influx* /usr/bin/envconsul

# make sure we have access to psql
apt-get -y -q install postgresql-client
