# templates, labels
# grunt example
resource google_compute_instance_template this {
  name_prefix    = "${var.name}-"
  project        = "${var.project}"
  description    = "compute vm instance group template"
  machine_type   = "${var.machine_type}"
  region         = "${var.region}"
  tags           = ["${var.tags}"]
  labels         = "${var.instance_labels}"
  can_ip_forward = "${var.can_ip_forward}"

  disk {
    auto_delete  = "${var.disk_auto_delete}"
    boot         = true
    source_image = "${var.compute_image}"
    type         = "PERSISTENT"
    disk_type    = "${var.disk_type}"
    disk_size_gb = "${var.disk_size_gb}"
    mode         = "${var.mode}"
  }

  service_account {
    scopes = ["${var.service_account_scopes}"]
  }

  network_interface = {
    subnetwork    = "${var.instance_subnetwork}"
    access_config = ["${var.access_config}"]
  }

  metadata = "${var.metadata}"

  # lifecycle {
  #   create_before_destroy = true
  # }
}

resource google_compute_region_instance_group_manager this {
  project                   = "${var.project}"
  name                      = "${var.name}"
  description               = "compute vm instance group"
  wait_for_instances        = "${var.wait_for_instances}"
  base_instance_name        = "${var.name}"
  instance_template         = "${google_compute_instance_template.this.self_link}"
  region                    = "${var.region}"
  distribution_policy_zones = ["${var.distribution_policy_zones}"]
  target_size               = "${var.replicas}"

  named_port {
    name = "${var.service_port_name}"
    port = "${var.service_port}"
  }

  # lifecycle {
  #   create_before_destroy = true
  # }
}
