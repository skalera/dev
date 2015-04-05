#!/bin/bash -e

echo 'running gvm setup...'

apt-get -y install bison

su - vagrant -c "bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)"
su - vagrant -c "source /home/vagrant/.gvm/scripts/gvm; gvm install go1.4.2; gvm use go1.4.2 --default"

echo '[[ -s "/home/vagrant/.gvm/scripts/gvm" ]] && source "/home/vagrant/.gvm/scripts/gvm"' >> /home/vagrant/.bash_profile
chown vagrant:vagrant /home/vagrant/.bash_profile
