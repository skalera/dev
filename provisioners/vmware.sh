#!/bin/sh -e

echo 'running vmware tools setup...'

apt-get -qq install -y perl build-essential

mount -o loop /home/vagrant/linux.iso /mnt
cd /tmp
tar xzf /mnt/VMwareTools-*.tar.gz
umount /mnt
rm /home/vagrant/linux.iso
cd vmware-tools-distrib
./vmware-install.pl -d
echo -n ".host:/ /mnt/hgfs vmhgfs rw,ttl=1,uid=my_uid,gid=my_gid,nobootwait 0 0" >> /etc/fstab
