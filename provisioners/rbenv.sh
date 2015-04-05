#!/bin/sh -e

echo 'running rbenv setup...'

apt-get -y install libssl-dev git-core libxml2-dev libxslt-dev libsqlite3-dev libffi-dev libpq-dev

su - vagrant -c "git clone https://github.com/sstephenson/rbenv.git ~/.rbenv"
su - vagrant -c "git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bash_profile
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bash_profile
chown vagrant:vagrant /home/vagrant/.bash_profile

su - vagrant -c "rbenv install 2.2.1"
su - vagrant -c "rbenv global 2.2.1"
su - vagrant -c "gem install bundler pry"
