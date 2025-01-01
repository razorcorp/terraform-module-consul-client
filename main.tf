# Project: terraform-module-consul-client
# Created by: Praveen Premaratne
# Created on: 31/12/2024 18:14

variable "host_ip" {
  description = "Host IP address to use for SSH"
}
variable "datacenter" {
  description = "Consul datacenter name"
}
variable "encryption_key" {
  description = "Encryption key used with mTLS configuration"
}
variable "consul_servers" {
  type = list(string)
  description = "List of Consul Servers addresses to join"
}
variable "certificate_authority" {
  type = object({
    certificate = string
    key         = string
  })
  description = "CA certificate and key to generate node certificate backend connections"
}
variable "service_definitions" {
  type = list(object({
    name = string
    address = optional(string)
    port = number
    tags = list(string)
    check = map(any)
  }))
  description = "List of service on the host to register with Consul"
}

locals {
  consul_tpl_vars = {
    DC                  = var.datacenter
    ENCRYPT             = var.encryption_key
    SERVERS             = var.consul_servers
    CONSUL_DATA_DIR     = "/var/consul"
    CONSUL_CONFIG_DIR   = "/etc/consul.d"
    CONSUL_CERT_DIR     = "/etc/consul.d/certs"
    IP_ADDR             = var.host_ip
    SERVICE_DEFINITIONS = var.service_definitions
    # [ for service_def in var.service_definitions: {
    #   name  = service_def.name
    #   port  = service_def.port
    #   tags  = service_def.tags
    #   check = {for k, v in service_def.check : k => can(tobool(v)) ? v: can(tonumber(v)) ? v : tostring(v)}
    # }]
  }

  consul_template = templatefile("${path.module}/templates/consul.sh.tftpl", local.consul_tpl_vars)
}

resource "null_resource" "provisioner" {

  connection {
    host  = var.host_ip
    agent = true
  }

  provisioner "file" {
    source      = "${path.module}/resources"
    destination = "/opt"
  }

  provisioner "file" {
    content     = var.certificate_authority.certificate
    destination = "/opt/resources/certs/consul-agent-ca.pem"
  }

  provisioner "file" {
    content     = var.certificate_authority.key
    destination = "/opt/resources/certs/consul-agent-ca-key.pem"
  }

  provisioner "file" {
    content     = local.consul_template
    destination = "/opt/resources/scripts/consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod -R +x /opt/resources/scripts",
      "mkdir -p /etc/consul.d/",
      "mv /opt/resources/certs /etc/consul.d/",
      "/opt/resources/scripts/init.sh",
      "/opt/resources/scripts/consul.sh"
    ]
  }
}