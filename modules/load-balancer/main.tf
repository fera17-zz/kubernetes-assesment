resource google_compute_target_tcp_proxy this {
  name            = "${var.prefix}-tcp-proxy"
  project         = "${var.project}"
  description     = "${var.prefix} lb tcp proxy"
  backend_service = "${google_compute_backend_service.this.self_link}"
}

resource google_compute_backend_service this {
  name        = "${var.prefix}-backend"
  protocol    = "TCP"
  port_name   = "${var.service_port_name}"
  timeout_sec = 10

  backend {
    group = "${var.instance_group}"
  }

  health_checks = ["${google_compute_health_check.this.self_link}"]
}

resource google_compute_health_check this {
  name               = "${var.prefix}-hc"
  timeout_sec        = 5
  check_interval_sec = 5

  tcp_health_check {
    port = "${var.service_port}"
  }
}

// Static IP address for HTTP forwarding rule
resource google_compute_global_address this {
  name = "${var.prefix}-ip"
}

resource google_compute_global_forwarding_rule this {
  project     = "${var.project}"
  name        = "${var.prefix}-frontend"
  target      = "${google_compute_target_tcp_proxy.this.self_link}"
  port_range  = "443"
  ip_protocol = "TCP"
#   ip_address  = "${google_compute_global_address.this.address}"
}

resource google_compute_firewall lb_external_fw {
  project = "${var.project}"
  name    = "${var.prefix}-${var.service_port}-service"

  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["${var.service_port}"]
  }

  source_ranges = ["0.0.0.0/0"]
}