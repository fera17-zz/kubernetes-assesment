output network {
  value = "${module.network.network_name}"
}

output subnetwork {
  value = "${module.network.private_subnetwork_name}"
}

#  bastion
output bastion_internal_ip {
  value = "${module.bastion.internal_ip}"
}

output bastion_external_ip {
  value = "${module.bastion.external_ip}"
}

# Access keys

output private_ssh_key {
  value     = "${module.ssh_key.private}"
  sensitive = true
}

output public_ssh_key {
  value     = "${module.ssh_key.public}"
  sensitive = true
}

output private_ssh_path {
  value = "${var.private_ssh_path}"
}

# Networking
output cidr_range {
  value = "${var.cidr_block}"
}

# TODO: inline return types
output nat_external_static_ip {
  value = "${module.nat.external_ip}"
}

output load_balancer_external_static_ip {
  value = "${module.load_balancer.external_ip}"
}

# output node_cloud_init {
#   value = "${base64decode(data.template_cloudinit_config.cloud_init.rendered)}"
# }

# cluster
output gcr_location {
  value = "${data.google_container_registry_repository.this.repository_url}"
}
