provider google {
  project = "${var.project}"
  region  = "${var.region}"
  version = "~> 1.20"
}

provider template {
  version = "~> 1.0"
}

provider tls {
  version = "2.0"
}

provider local {
  version = "~> 1.3"
}

provider null {
  version = "~> 1.0"
}

resource random_id token_prefix {
  byte_length = 5
}

resource random_id token_suffix {
  byte_length = 3
}

resource random_id cluster_uid {
  byte_length = 8
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the Network & corresponding Router to attach other resources to
# Networks that preserve the default route are automatically enabled for Private Google Access to GCP services
# provided subnetworks each opt-in; in general, Private Google Access should be the default.
# ---------------------------------------------------------------------------------------------------------------------

module network {
  source = "../../../tf-modules/network"

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
  source     = "../../../tf-modules/nat"
  project    = "${var.project}"
  prefix     = "${var.prefix}"
  region     = "${var.region}"
  network    = "${module.network.network_link}"
  subnetwork = "${module.network.private_subnetwork_link}"
}

module masters {
  source = "../../../tf-modules/compute"

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
  replicas                  = "2"
  service_port              = "${var.master_service_port}"
  service_port_name         = "apiserver"
  wait_for_instances        = true

  instance_labels = "${merge(local.labels,
    map("vmrole", "master"),
    map("visibility", "private")
  )}"

  metadata {
    ssh-keys = "${local.ssh_keys}"

    # user-data          = "${data.template_cloudinit_config.master.rendered}"
    # user-data-encoding = "base64"
    # pod-cidr           = "${var.pod_cidr}"
  }
}

module workers {
  source = "../../../tf-modules/compute"

  name                      = "${var.prefix}-worker"
  project                   = "${var.project}"
  region                    = "${var.region}"
  tags                      = "${local.master_tags}"
  machine_type              = "${var.master_type}"
  instance_subnetwork       = "${module.network.private_subnetwork_name}"
  can_ip_forward            = "true"
  compute_image             = "${data.google_compute_image.ubuntu.self_link}"
  disk_size_gb              = "50"
  distribution_policy_zones = ["${data.google_compute_zones.available.names}"]
  replicas                  = 3
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

# module workers {
#   source = "../../../tf-modules/terraform-google-managed-instance-group-mod"

#   project                = "${var.project}"
#   region                 = "${var.region}"
#   zone                   = "${var.zone}"
#   name                   = "${var.res_prefix}-workers"
#   size                   = "${var.worker_group_size}"
#   target_tags            = ["${var.res_prefix}-nat-${var.region}", "${var.res_prefix}-workers", "${module.nat.routing_tag_regional}"]
#   http_health_check      = false
#   zonal                  = false
#   service_account_scopes = ["${var.service_account_scopes}"]
#   network                = "${module.network.network_name}"
#   subnetwork             = "${module.network.subnetwork_name}"
#   access_config          = ["${var.access_config}"]
#   can_ip_forward         = true
#   machine_type           = "${var.master_type}"
#   compute_image          = "${var.os_image}"

#   metadata = {
#     "owner"    = "${var.owner}"
#     "ssh-keys" = "core:${file("${var.pub_key}")}"
#   }
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
  source = "../../../tf-modules/bastion"

  create     = true
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

