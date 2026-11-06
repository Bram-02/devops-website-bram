terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0"
    }
  }
}

# Kredensial dibaca dari ~/.config/openstack/clouds.yaml
provider "openstack" {
  cloud = "devstack"
}

resource "openstack_compute_instance_v2" "lab" {
  name            = "tofu-cirros"
  image_name      = "cirros-0.6.3-x86_64-disk"
  flavor_name     = "cirros256"
  security_groups = ["default"]

  network {
    name = "private"
  }
}

output "ip_privat" {
  value = openstack_compute_instance_v2.lab.access_ip_v4
}
