# Skalera development VM

Use this VM for Skalera development. It comes with `docker` plus the `progrium/consul` and `progrium/registrator` images, and has DNS configured for all containers so that it can lookup services in `consul`.

It auto-registers the published ports of all `docker` containers, which then can be accessed through `consul` using the DNS or REST API.

## DNS API

Do a DNS SRV query to get the name of the consul instance (which should be `consul.services.consul.`)

    require 'resolv'
    resolver = Resolv::DNS.new
    consul = resolver.getresource('consul', Resolv::DNS::Resource::IN::SRV)
    => #<Resolv::DNS::Resource::IN::SRV:0x007fe6d41b15d0 @port=6379, @priority=1, @target=#<Resolv::DNS::Name: dev.node.dc1.consul.>, @ttl=0, @weight=1>

## REST API

You can use the REST API directly, assuming that the server name is `consul.service.consul`

    require 'net/http'
    require 'json'
    consul = ENV['CONSUL'] || 'consul'
    uri = URI("http://#{consul}:8500/v1/catalog/service/redis")
    json = Net::HTTP.get(uri)
    hash = JSON.parse(json)
    => [{"Node"=>"dev", "Address"=>"172.16.57.156", "ServiceID"=>"dev:redis:6379", "ServiceName"=>"redis", "ServiceTags"=>nil, "ServicePort"=>6379}]

If you are developing on your laptop, you can set the environment variable `CONSUL` to the IP address of the vagrant box running `consul`.

## Image debugging

If you want a shell inside a container, use

    docker run -it --rm progrium/busybox sh

if you need additional packages (busybox is stripped down) use `opkg-install`, e.g. to get `curl`

    opkg-install curl

## VM template
The VM is built using `packer` and [this configuration](https://github.com/skalera/packer-dev)
