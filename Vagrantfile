# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define 'dev' do |dev|
    dev.vm.box = ENV['BOX_NAME'] || 'skalera/dev'
    dev.vm.hostname = 'dev'
    dev.vm.network 'private_network', type: 'dhcp'

    dev.vm.provider 'vmware_fusion' do |fusion|
      fusion.vmx['memsize'] = '8192'
      fusion.vmx['numvcpus'] = '4'
    end

    dev.vm.provision 'shell', path: 'scripts/_docker.sh'

    # load all files in scripts
    scripts = Dir.glob('scripts/*.sh').reject { |file| file.match(/\/_/) }

    scripts.each do |script|
      dev.vm.provision 'shell', path: script
    end

    # config.vm.provision 'chef_solo' do |chef|
    #   chef.add_recipe 'gvm'
    # end

    dev.vm.provision 'shell', path: 'scripts/_ip.sh'

    # if you want to test a docker repo from your host, e.g. influxdb, uncomment this:
    # dev.vm.synced_folder '../influxdb-docker/', '/influxdb'
  end
end
