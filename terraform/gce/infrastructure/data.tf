locals {
  labels = {
    environment = "${var.environment}"
    project     = "${var.project}"
  }

  tags = []

  ssh_pub_key_without_new_line = "${replace(module.ssh_key.public, "\n", "")}"
  ssh_keys = "${var.ssh_user}:${local.ssh_pub_key_without_new_line} ${var.ssh_user}"
  master_tags = ["${var.prefix}-master", "private"]
  worker_tags = ["${var.prefix}-worker", "private"]
  etcd_tags = ["${var.prefix}-etcd", "private"]
}

data google_compute_image ubuntu {
  family  = "ubuntu-1804-lts"
  project = "ubuntu-os-cloud"
}

data google_compute_image coreos {
  family  = "coreos-stable"
  project = "coreos-cloud"
}

data google_compute_zones available {
  region = "${var.region}"
}
