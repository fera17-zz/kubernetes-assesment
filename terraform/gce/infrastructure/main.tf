# ---------------------------------------------------------------------------------------------------------------------
# Create the Network & corresponding Router to attach other resources to
# Networks that preserve the default route are automatically enabled for Private Google Access to GCP services
# provided subnetworks each opt-in; in general, Private Google Access should be the default.
# ---------------------------------------------------------------------------------------------------------------------

module network {
  source = "../../modules/gce/network"

  project            = "${var.project}"
  region             = "${var.region}"
  prefix             = "${var.prefix}"
  cidr_block         = "${var.cidr_block}"
  public_cidr_block  = "${var.public_cidr_block}"
  private_cidr_block = "${var.private_cidr_block}"
  admin_whitelist    = "${var.admin_whitelist}"
}

# ---------------------------------------------------------------------------------------------------------------------
# Public Egress Config
# Public internet access for instances with addresses is automatically configured by the default gateway for 0.0.0.0/0 [Bastion]
# External access is configured with Cloud NAT, which subsumes egress traffic for instances without external addresses [Master, Worker]
# ---------------------------------------------------------------------------------------------------------------------

module nat {
  source     = "../../modules/gce/nat"
  project    = "${var.project}"
  prefix     = "${var.prefix}"
  region     = "${var.region}"
  network    = "${module.network.network_link}"
  subnetwork = "${module.network.private_subnetwork_link}"
}

# ---------------------------------------------------------------------------------------------------------------------
# Masters/Controll Plane, Workers, ETCD, Bastion configuraiton
# External access is configured with Cloud NAT, which subsumes egress traffic for instances without external addresses [Master, Worker]
# ---------------------------------------------------------------------------------------------------------------------

module masters {
  source = "../../modules/gce/compute"

  name                      = "${var.prefix}-master"
  project                   = "${var.project}"
  region                    = "${var.region}"
  tags                      = "${local.master_tags}"
  machine_type              = "${var.master_type}"
  instance_subnetwork       = "${module.network.private_subnetwork_name}"
  compute_image             = "${data.google_compute_image.ubuntu.self_link}"
  distribution_policy_zones = ["${data.google_compute_zones.available.names}"]
  replicas                  = "${var.master_size}"
  service_port              = "${var.master_service_port}"
  service_port_name         = "kubeapi"

  instance_labels = "${merge(local.labels,
    map("vmrole", "master"),
    map("visibility", "private")
  )}"

  metadata {
    ssh-keys           = "${local.ssh_keys}"
    user-data          = "${data.template_cloudinit_config.cloud_init.rendered}"
    user-data-encoding = "base64"
  }
}

module workers {
  source = "../../modules/gce/compute"

  name                      = "${var.prefix}-worker"
  project                   = "${var.project}"
  region                    = "${var.region}"
  tags                      = "${local.worker_tags}"
  machine_type              = "${var.master_type}"
  instance_subnetwork       = "${module.network.private_subnetwork_name}"
  compute_image             = "${data.google_compute_image.ubuntu.self_link}"
  distribution_policy_zones = ["${data.google_compute_zones.available.names}"]
  replicas                  = "${var.worker_size}"

  instance_labels = "${merge(local.labels,
    map("vmrole", "worker"),
    map("visibility", "private")
  )}"

  metadata {
    ssh-keys           = "${local.ssh_keys}"
    user-data          = "${data.template_cloudinit_config.cloud_init.rendered}"
    user-data-encoding = "base64"
  }
}

module etcd {
  source = "../../modules/gce/compute"

  name                      = "${var.prefix}-etcd"
  project                   = "${var.project}"
  region                    = "${var.region}"
  tags                      = "${local.etcd_tags}"
  machine_type              = "${var.etcd_type}"
  instance_subnetwork       = "${module.network.private_subnetwork_name}"
  compute_image             = "${data.google_compute_image.ubuntu.self_link}"
  distribution_policy_zones = ["${data.google_compute_zones.available.names}"]
  replicas                  = "${var.etcd_size}"
  service_port              = "${var.etcd_service_port}"
  service_port_name         = "etcd"

  instance_labels = "${merge(local.labels,
    map("vmrole", "etcd"),
    map("visibility", "private")
  )}"

  metadata {
    ssh-keys           = "${local.ssh_keys}"
    user-data          = "${data.template_cloudinit_config.cloud_init.rendered}"
    user-data-encoding = "base64"
  }
}

module load_balancer {
  source = "../../modules/gce/load-balancer"

  name              = "${var.prefix}-masters"
  project           = "${var.project}"
  region            = "${var.region}"
  prefix            = "${var.prefix}"
  network           = "${module.network.network_name}"
  service_port_name = "${var.prefix}-api-https"
  service_port      = "${var.master_service_port}"
  cidr_block        = "${var.cidr_block}"
  admin_whitelist   = "${var.admin_whitelist}"
  nat_ips           = "${module.nat.external_ip}"
  instance_group    = "${module.masters.instance_group}"
  service_port_name = "kubeapi"
}

# BASTION
module bastion {
  source = "../../modules/gce/bastion"

  create          = "${var.jumpbox_create}"
  prefix          = "${var.prefix}"
  project         = "${var.project}"
  machine_type    = "${var.jumpbox_type}"
  region          = "${var.region}"
  cidr_block      = "${var.cidr_block}"
  image           = "${data.google_compute_image.ubuntu.self_link}"
  zone            = "${var.region}-a"
  network         = "${module.network.network_name}"
  subnetwork      = "${module.network.public_subnetwork_name}"
  admin_whitelist = "${var.admin_whitelist}"

  labels = "${merge(local.labels,
    map("vmrole", "jumpbox"),
    map("visibility", "private")
  )}"

  metadata {
    ssh-keys           = "${local.ssh_keys}"
    user-data          = "${data.template_cloudinit_config.bastion_cloud_init.rendered}"
    user-data-encoding = "base64"
  }
}
