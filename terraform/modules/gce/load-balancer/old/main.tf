# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A NETWORK LOAD BALANCER
# This module deploys a GCP Regional Network Load Balancer
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/examples/network-load-balancer/main.tf
# https://github.com/GoogleCloudPlatform/terraform-google-lb/blob/master/main.tf

resource google_compute_global_forwarding_rule https {
  project     = "${var.project}"
  name        = "${var.prefix}-lb-https"
  ip_address  = "${google_compute_global_address.ssl.address}"
  target      = "${google_compute_target_https_proxy.ssl.self_link}"
  ip_protocol = "TCP"
  port_range  = "443"

  #   labels = var.custom_labels
  depends_on = ["google_compute_global_address.ssl"]
}

# ---------------------------------------------------------------------------------------------------------------------
# public - allow ingress from anywhere
# ---------------------------------------------------------------------------------------------------------------------

resource google_compute_firewall public_allow_inbound {
  name = "${var.prefix}-public-allow-ingress"

  project = "${var.project}"
  network = "${var.network}"

  target_tags = ["public"]
  direction   = "INGRESS"

  #  NATS IP & Admin IPs
  # Allow load balancer access to the API instances
#   These IP ranges are required for health checks
  source_ranges = ["${var.admin_whitelist}", "${var.nat_ips}", "130.211.0.0/22", "35.191.0.0/16", "130.211.0.0/22", "35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]

  priority = "1000"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "${var.service_port}"]
  }
}



# https://github.com/gruntwork-io/terraform-google-load-balancer/blob/master/main.tf
resource google_compute_target_https_proxy ssl {
  name             = "${var.prefix}-https-proxy"
#   backend_service  = "${google_compute_backend_service.ssl.self_link}"
url_map = ""
  ssl_certificates = ["${google_compute_ssl_certificate.lb.self_link}"]
}

resource google_compute_backend_service ssl {
  project       = "${var.project}"
  name          = "${var.prefix}-tls-termination"
  description   = "ssl backends"
  health_checks = ["${google_compute_health_check.ssl.self_link}"]
  protocol      = "TCP"
  port_name     = "${var.service_port_name}"

  backend {
    group = "${var.instance_group}"
  }
}

resource google_compute_health_check ssl {
  name               = "${var.prefix}-master-apiserver-up"
  description        = "TCP health check for kube-apiserver"
  check_interval_sec = 5
  timeout_sec        = 5

  healthy_threshold   = 1
  unhealthy_threshold = 3

  tcp_health_check {
    port = "6443"
  }
}

resource google_compute_global_address ssl {
  name = "${var.prefix}-lb-ssl"
  address_type = "EXTERNAL"
}

resource google_compute_firewall loadbalancer_forward_service {
  project     = "${var.project}"
  name        = "${var.prefix}-${var.service_port}-service"
  network     = "${var.network}"
  description = "traffic from load balancer to services"
  priority    = "1000"
  direction   = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["${var.service_port}"]
  }

  target_tags = ["${var.target_tags}"]
}
