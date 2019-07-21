resource google_compute_firewall ssh {
  count   = "${var.create ? 1 : 0}"
  name    = "${var.prefix}-ext-fw"
  network = "${var.network}"
  description = "ssh access"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["bastion"]
  source_ranges = "${var.admin_whitelist}"
}

resource google_compute_firewall int {
  name    = "${var.prefix}-int-fw"
  network = "${var.network}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "esp"
  }

  allow {
    protocol = "ah"
  }

  allow {
    protocol = "sctp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = ["${var.cidr_block}"]
}

# resource google_compute_firewall int-egress {
#   name    = "${var.prefix}-int-egress-fw"
#   network = "${var.network}"
# #   restrinct it a bit
#   allow {
#     protocol = "all"
#   }

#   direction          = "EGRESS"
#   destination_ranges = ["0.0.0.0/0"]
# }
