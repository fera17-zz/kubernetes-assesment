# terraform {
#   # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
#   required_version = ">= 0.12"
# }

resource google_compute_network this {
  name                    = "${var.prefix}-network"
  auto_create_subnetworks = "false"
  description             = "k8s network"

  # A global routing mode can have an unexpected impact on load balancers; always use a regional mode
  routing_mode = "REGIONAL"
}

# ---------------------------------------------------------------------------------------------------------------------
# Public Subnetwork Config
# Public internet access for instances with addresses is automatically configured by the default gateway for 0.0.0.0/0
# External access is configured with Cloud NAT, which subsumes egress traffic for instances without external addresses
# ---------------------------------------------------------------------------------------------------------------------

resource google_compute_subnetwork public {
  name                     = "${var.prefix}-public"
  project                  = "${var.project}"
  region                   = "${var.region}"
  network                  = "${google_compute_network.this.self_link}"
  private_ip_google_access = true
  ip_cidr_range            = "${var.public_cidr_block}"
}

# ---------------------------------------------------------------------------------------------------------------------
# Private Subnetwork Config
# ---------------------------------------------------------------------------------------------------------------------

resource google_compute_subnetwork private {
  name                     = "${var.prefix}-private"
  project                  = "${var.project}"
  region                   = "${var.region}"
  network                  = "${google_compute_network.this.self_link}"
  private_ip_google_access = true
  ip_cidr_range            = "${var.private_cidr_block}"
}

# ---------------------------------------------------------------------------------------------------------------------
# private - allow ingress from within this network
# ---------------------------------------------------------------------------------------------------------------------

resource google_compute_firewall nodes_firewall {
  name = "${var.prefix}-nodes-firewall"
  project = "${var.project}"
  network = "${google_compute_network.this.self_link}"
  description = "node firewall rules"
  target_tags = ["private"]
  direction   = "INGRESS"

  source_ranges = [
    "${google_compute_subnetwork.public.ip_cidr_range}",
    "${google_compute_subnetwork.private.ip_cidr_range}",
  ]

  priority = "1000"

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "icmp"
  }
}

# resource google_compute_firewall private_allow_all_network_inbound {
#   name = "${var.prefix}-private-allow-ingress"


#   project = "${var.project}"
#   network = "${google_compute_network.this.self_link}"


#   target_tags = ["private"]
#   direction   = "INGRESS"


#   source_ranges = [
#     "${google_compute_subnetwork.public.ip_cidr_range}",
#     "${google_compute_subnetwork.private.ip_cidr_range}",
#   ]


#   priority = "1000"


#   allow {
#     protocol = "tcp"
# 	ports    = ["1-65535"]
#   }


#   allow {
#     protocol = "udp"
# 	ports    = ["1-65535"]
#   }


#   allow {
#     protocol = "icmp"
#   }


#   # source_ranges = ["${var.cidr_block}"]
#   source_ranges = ["0.0.0.0/0"]
# }


# resource google_compute_firewall int {
#   name    = "${var.prefix}-int-fw"
#   network = "${var.network}"


#   allow {
#     protocol = "icmp"
#   }


#   allow {
#     protocol = "tcp"
#   }


#   allow {
#     protocol = "udp"
#   }


#   allow {
#     protocol = "esp"
#   }


#   allow {
#     protocol = "ah"
#   }


#   allow {
#     protocol = "sctp"
#   }


#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }


#   source_ranges = ["${var.cidr_block}"]
# }

