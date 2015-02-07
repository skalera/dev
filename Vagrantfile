# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  docker_script = 'scripts/docker.sh'

  config.vm.define 'dev' do |dev|
    dev.vm.box = 'skalera/dev'
    dev.vm.hostname = 'dev'
    dev.vm.network 'private_network', type: 'dhcp'
    dev.vm.provision 'shell', path: docker_script

    # load all files in scripts
    scripts = Dir.glob('scripts/*.sh').reject { |file| file.match(docker_script) }

    scripts.each do |script|
      dev.vm.provision 'shell', path: script
    end

    # if you want to test a docker repo from your host, e.g. influxdb, uncomment this:
    # dev.vm.synced_folder "../influxdb-docker/", "/docker"
  end

end

