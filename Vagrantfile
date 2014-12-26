# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'skalera/dev'
  config.vm.hostname = 'dev'
  config.vm.network 'private_network', type: 'dhcp'
  config.vm.provision 'shell', path: 'scripts/docker.sh'

  # if you want to test a docker repo from your host, e.g. influxdb, uncomment this:
  # config.vm.synced_folder "../influxdb-docker/", "/docker"
end

