output network {
  value = "${module.network.network_name}"
}

output subnetwork {
  value = "${module.network.private_subnetwork_name}"
}

# output worker_instance_group {
#   value = "${module.workers.region_instance_group}"
# }

output bastion_internal_ip {
  value = "${module.bastion.internal_ip}"
}

output bastion_external_ip {
  value = "${module.bastion.external_ip}"
}

output private_ssh_key {
  value = "${module.ssh_key.private}"
  sensitive = true
}

output public_ssh_key {
  value = "${module.ssh_key.public}"
  sensitive = true
}

output private_ssh_path {
  value = "${var.private_ssh_path}"
}

# output masters_self_links {
#   value = "${module.masters.region_instance_group}"
# }
# output masters_instances {
#   value = "${module.masters.instances}"
# }

# output lb_ip {module.masters.region_instance_group
#   value = "${module.gce-lb.external_ip}"
# }

# Networking
output cidr_range {
  value = "${var.cidr_block}"
}
# TODO: inline return types
output nat_external_static_ip {
  value = "${module.nat.external_ip}"
}

# output load_balancer_external_static_ip {
#   value = "${module.load_balancer.external_ip}"
# }

# cluster
output claster_id {
  value = "${random_id.cluster_uid.hex}"
}

output claster_token {
  value = "${random_id.token_prefix.hex}.${random_id.token_suffix.hex}"
}
