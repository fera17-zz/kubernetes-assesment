output instance_template {
  description = "Link to the instance_template for the group"
  value       = "${google_compute_instance_template.this.*.self_link}"
}

output instance_group {
  description = "Link to the `instance_group` property of the region instance group manager resource."
  value       = "${element(concat(google_compute_region_instance_group_manager.this.*.instance_group, list("")), 0)}"
}
