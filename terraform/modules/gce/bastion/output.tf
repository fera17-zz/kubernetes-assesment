output internal_ip {
  description = "The internal IP of the bastion host."
  value       = "${ join(" ", google_compute_instance.this.*.network_interface.0.network_ip) }"
}

output external_ip {
  description = "The public IP of the bastion host."
  value       = "${ join(" ", google_compute_instance.this.*.network_interface.0.access_config.0.assigned_nat_ip) }"
}
