#!/bin/sh -ex

echo 'running rbenv setup...'

apt-get -y install libssl-dev git-core libxml2-dev libxslt-dev libsqlite3-dev libffi-dev libpq-dev

su - vagrant -c 'git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv'
su - vagrant -c 'git clone https://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build'

BASH_PROFILE=/home/vagrant/.bash_profile

echo 'export PATH=$HOME/.rbenv/bin:$PATH' >> ${BASH_PROFILE}
echo 'eval "$(rbenv init -)"' >> ${BASH_PROFILE}
chown vagrant:vagrant ${BASH_PROFILE}

cat ${BASH_PROFILE}

ls /home/vagrant/.gvm
ls /home/vagrant/.gvm/scripts

echo 'gem: --no-rdoc --no-ri' > /etc/gemrc
su - vagrant -c 'rbenv install 2.2.3'
su - vagrant -c 'rbenv global 2.2.3'
su - vagrant -c 'gem install bundler pry'
