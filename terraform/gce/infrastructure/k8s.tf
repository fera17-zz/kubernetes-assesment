provider google {
  project = "${var.project}"
  region  = "${var.region}"
  version = "~> 1.20"
}

terraform {
  # The example is not compatible with any versions below 0.12.
  # required_version = ">= 0.12"
  # Back End
  backend "gcs" {}
}

provider template {
  version = "2.1.2"
}

# provider template {
#   version = "~> 1.0"
# }

provider tls {
  version = "2.0"
}

provider local {
  version = "~> 1.3"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Network & corresponding Router to attach other resources to
# Networks that preserve the default route are automatically enabled for Private Google Access to GCP services
# provided subnetworks each opt-in; in general, Private Google Access should be the default.
# ---------------------------------------------------------------------------------------------------------------------

module network {
  source = "../../modules/gce/network"

  project                = "${var.project}"
  region                 = "${var.region}"
  prefix                 = "${var.prefix}"
  cidr_block             = "${var.cidr_block}"
  public_cidr_block      = "${var.public_cidr_block}"
  private_cidr_block     = "${var.private_cidr_block}"
  secondary_public_cidr  = "${var.secondary_public_cidr}"
  secondary_private_cidr = "${var.secondary_private_cidr}"
  admin_whitelist        = "${var.admin_whitelist}"
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

module masters {
  source = "../../modules/gce/compute"

  name                      = "${var.prefix}-master"
  project                   = "${var.project}"
  region                    = "${var.region}"
  tags                      = "${local.master_tags}"
  machine_type              = "${var.master_type}"
  instance_subnetwork       = "${module.network.private_subnetwork_name}"
  can_ip_forward            = "true"
  compute_image             = "${data.google_compute_image.ubuntu.self_link}"
  disk_size_gb              = "50"
  distribution_policy_zones = ["${data.google_compute_zones.available.names}"]
  replicas                  = "${var.master_group_size}"
  service_port              = "${var.master_service_port}"
  service_port_name         = "apiserver"
  wait_for_instances        = true

  instance_labels = "${merge(local.labels,
    map("vmrole", "master"),
    map("visibility", "private")
  )}"

  metadata {
    ssh-keys = "${local.ssh_keys}"
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
  can_ip_forward            = "true"
  compute_image             = "${data.google_compute_image.ubuntu.self_link}"
  disk_size_gb              = "50"
  distribution_policy_zones = ["${data.google_compute_zones.available.names}"]
  replicas                  = "${var.worker_group_size}"
  wait_for_instances        = true

  instance_labels = "${merge(local.labels,
    map("vmrole", "worker"),
    map("visibility", "private")
  )}"

  metadata {
    ssh-keys = "${local.ssh_keys}"
  }
}

# resource google_compute_firewall calico {
#   name    = "${var.prefix}-calico-ipip1"
#   network = "${module.network.network_name}"

#   allow {
#     protocol = "ipip"
#   }

#   source_ranges = ["${compact(list("10.128.0.0/9", "${var.cidr_block}"))}"]
# }

# resource google_compute_firewall k8s_traffic {
#   name    = "${var.prefix}-all-traffic"
#   network = "${module.network.network_name}"

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

#   source_ranges = ["${var.pod_cidr}"]
# }

# TODO: labels
# module load_balancer {
#   source = "../../../tf-modules/load-balancer"

#   project           = "${var.project}"
#   region            = "${var.region}"
#   prefix            = "${var.prefix}"
#   network           = "${module.network.network_name}"
#   service_port_name = "${var.prefix}-api-https"
#   service_port      = "${var.master_service_port}"
#   cidr_block        = "${var.cidr_block}"
#   admin_whitelist   = "${var.admin_whitelist}"
#   nat_ips           = "${module.nat.external_ip}"
#   target_tags       = ["${var.prefix}-master", "controller"]
#   instance_group    = "${module.masters.instance_group}"
#   service_port_name = "apiserver"
# }

# IP ADDRESS

# JUMBPROX
# resource google_compute_address jumpbox_internal {
#   name         = "${var.prefix}-jumpbox-internal"
#   address_type = "INTERNAL"
#   subnetwork   = "${module.network.public_subnetwork_link}"
#   address      = "${var.jumpbox_internal_ip}"
#   description  = "static private ip to access jumpbox"
#   region       = "${var.region}"

#   labels = "${merge(local.labels,
#     map("vmrole", "jumpbox"),
#   map("visibility", "private")
#   )}"
# }

# BASTION
module bastion {
  source = "../../modules/gce/bastion"

  create     = "${var.jumpbox_create}"
  prefix     = "${var.prefix}"
  project    = "${var.project}"
  pub_key    = "${module.ssh_key.public}"
  ssh_keys   = "${local.ssh_keys}"
  type       = "${var.jumpbox_type}"
  region     = "${var.region}"
  cidr_block = "${var.cidr_block}"
  image      = "${data.google_compute_image.ubuntu.self_link}"

  # internal_ip     = "${google_compute_address.jumpbox_internal.address}"
  zone            = "${var.region}-a"
  network         = "${module.network.network_name}"
  subnetwork      = "${module.network.public_subnetwork_name}"
  admin_whitelist = "${var.admin_whitelist}"

  labels = "${merge(local.labels,
    map("vmrole", "jumpbox"),
    map("visibility", "private")
  )}"
}

# curl "http://metadata.google.internal/computeMetadata/v1/instance/hostname" \
# -H "Metadata-Flavor: Google"

