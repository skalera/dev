# Skalera development VM

Use this VM for development. It comes with `docker` plus `progrium/consul` and `progrium/registrator`.

It auto-registers the published ports of all `docker` containers, which then can be accessed through `consul`
using the REST API, e.g.

    curl http://172.16.57.156:8500/v1/catalog/service/redis
    [{"Node":"dev","Address":"172.16.57.156","ServiceID":"dev:redis:6379","ServiceName":"redis","ServiceTags":null,"ServicePort":6379}]

or using the DNS API

    require 'resolv'
    # the VM should be setup with DNS resolving, so localhost (127.0.0.1) can be used
    resolver = Resolv::DNS.new(nameserver: ['172.16.57.156'], search: ['service.consul'], ndot: 1)
    redis = resolver.getresource('redis', Resolv::DNS::Resource::IN::SRV)

## VM template
The VM is built using `packer` and [this configuration](https://github.com/skalera/packer-dev)
