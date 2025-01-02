# On-prem Consul Client deployment

Terraform module for provisioning Consul client for on-prem and baremetal servers with `null_resource` provider.

Module uses SSH to configure the host similar to Ansible using Bash scripts generated with Terraform templates.

> If bundled with other `null_resource` provisioners, consider chaining them with `depends_on` or set `-parallelism=1` to avoid package manager issues such as APT or DPKG lock 

## Inputs
- `host_ip` - Host IP address to use for SSH
- `datacenter` - Consul datacenter name
- `encryption_key` - Encryption key used with mTLS configuration
- `consul_servers` - List of Consul Servers addresses to join
- `certificate_authority` - CA certificate and key to generate node certificate backend connections
  - `certificate` - CA certificate PEM context
  - `key` - CA private key PEM context
- `service_definitions` - List of service on the host to register with Consul
  - `name` - Name of the service
  - `address` - (**Optional**)  Service-specific IP address or hostname. Default to node IP
  - `port` - Port of the service exposed to outside network
  - `tags` - List of values that add service-level labels. These will be used as an anti-entropy mechanism
  - `check` - Dynamic key-value map, refer to [Health check configuration reference](https://developer.hashicorp.com/consul/docs/services/configuration/checks-configuration-reference) for full documentation

### Example
```terraform
module "provisioner" {
  source         = "git@github.com:praveenprem/terraform-module-consul-client.git?ref=master"
  host_ip        = "10.10.1.12"
  datacenter     = "dc1"
  encryption_key = local.encryption_key
  consul_servers = ["10.10.1.8", "10.10.1.9", "10.10.1.10"]
  certificate_authority = {
    certificate = local.ca_cert
    key = local.ca_key
  }
  service_definitions = [
    {
      name = "nginx"
      port = 80
      tags = ["reverse-proxy", "prod"]
      check = {
        tcp = "localhost:80"
        interval = "10s"
        timeout = "5s"
      }
    }
  ]
}
```