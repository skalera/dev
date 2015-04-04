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

if [ -z "${DOCKER_PASSWORD}" ]; then
    echo "DOCKER_PASSWORD not set, skipping skalera/sidekiq"
else
    docker login -u skalerajenkins -e martin.englund@skalera.com -p ${DOCKER_PASSWORD}
    docker pull skalera/sidekiq
fi

# add influx and envconsul command to VM image
wget -O /usr/bin/influx https://s3-us-west-2.amazonaws.com/skalera/vagrant/influx-0.9.0_rc16
wget -O /usr/bin/envconsul https://s3-us-west-2.amazonaws.com/skalera/vagrant/envconsul
chmod 755 /usr/bin/influx /usr/bin/envconsul
