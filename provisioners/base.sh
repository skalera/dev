#!/bin/sh -e

echo 'running base setup...'

apt-get -qq update
apt-get -qq -y upgrade

# Check that HTTPS transport is available to APT
if [ ! -e /usr/lib/apt/methods/https ]; then
	apt-get install -y apt-transport-https
fi

apt-get -qq -y install linux-headers-$(uname -r) vim curl libreadline6-dev mosh

sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

echo "UseDNS no" >> /etc/ssh/sshd_config
