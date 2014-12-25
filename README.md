# Skalera development VM

Use this VM for development. It comes with `docker` plus `progrium/consul` and `progrium/registrator`.

It auto-registers the published ports of all `docker` containers, which then can be accessed through `consul`
using the REST API, e.g.

```
curl http://localhost:8500/v1/catalog/services
```

## VM template
The VM is built using `packer` and [this configuration](https://github.com/skalera/packer-dev)
