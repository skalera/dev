# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "skalera/dev"
  config.vm.hostname = 'dev'
  config.vm.network "private_network", type: 'dhcp'
  config.vm.provision "shell", path: 'scripts/docker.sh'
end

