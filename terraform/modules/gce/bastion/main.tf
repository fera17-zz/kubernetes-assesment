resource google_compute_instance this {
  count                     = "${var.create ? 1 : 0}"
  name                      = "${var.prefix}-bastion"
  machine_type              = "${var.machine_type}"
  zone                      = "${var.zone}"
  project                   = "${var.project}"
  tags                      = "${var.tags}"
  allow_stopping_for_update = "true"

  labels = "${merge(var.labels,
    map("vmrole", "bastion"),
    map("visiblity", "private")
  )}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  metadata = "${var.metadata}"

  network_interface {
    subnetwork    = "${var.subnetwork}"
    access_config = {}
  }
}
