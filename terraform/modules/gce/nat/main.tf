# terraform {
#   # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
#   required_version = ">= 0.12"
# }
# https://github.com/GoogleCloudPlatform/terraform-google-nat-gateway/blob/1.2.2/main.tf
resource google_compute_router this {
  name    = "${var.prefix}-router"
  project = "${var.project}"
  region  = "${var.region}"
  network = "${var.network}"
}

resource google_compute_address this {
  count       = 1                                     # TODO: make it configurable
  name        = "nat-external-address-${count.index}"
  description = "NAT ips"
  region      = "${var.region}"
  project     = "${var.project}"
}

resource google_compute_router_nat this {
  name                   = "${var.prefix}-nat"
  project                = "${var.project}"
  region                 = "${var.region}"
  router                 = "${google_compute_router.this.name}"
  nat_ips                = ["${google_compute_address.this.*.self_link}"] #address[*].
  nat_ip_allocate_option = "MANUAL_ONLY"

  # "Manually" define the subnetworks for which the NAT is used, so that we can exclude the public subnetwork
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = "${var.subnetwork}"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

output external_ip {
  value = ["${google_compute_address.this.*.address}"]
}
