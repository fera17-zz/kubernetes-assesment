resource google_compute_firewall ssh {
  count       = "${var.create ? 1 : 0}"
  name        = "${var.prefix}-ssh-external"
  network     = "${var.network}"
  project     = "${var.project}"
  description = "ssh access"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["bastion"]
  source_ranges = "${var.admin_whitelist}"
}

resource google_compute_firewall bastion_internal {
  name    = "${var.prefix}-int-egress-fw"
  network = "${var.network}"
  project = "${var.project}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }

  source_tags = ["bastion"]
  target_tags = ["private"]
}
