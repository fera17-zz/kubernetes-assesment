output external_ip {
  description = "regional external ip address of the forwarding rule."
  value       = "${google_compute_global_forwarding_rule.this.ip_address}"
}

# output target_pool {
#   description = "The `self_link` to the target pool resource created."
#   value       = "${google_compute_target_pool.default.self_link}"
# }

