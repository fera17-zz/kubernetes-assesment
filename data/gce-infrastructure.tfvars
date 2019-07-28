environment = "dev"

ssh_user = "k8s"

prefix = "k8s"

master_size = 0

worker_size = 0

etcd_size = 0

jumpbox_create = true

jumpbox_type = "f1-micro"

master_type = "g1-small"

worker_type = "g1-small"

etcd_type = "f1-micro"

access_config = []

update_strategy = "NOME"

service_account_scopes = [
  "https://www.googleapis.com/auth/devstorage.read_only",
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/trace.append",
  "https://www.googleapis.com/auth/compute",
  "https://www.googleapis.com/auth/monitoring",
]

jumpbox_internal_ip = "10.240.0.2"

admin_whitelist = ["86.1.27.129"]

master_service_port = 6443

etcd_service_port = 2379

# https://www.site24x7.com/tools/ipv4-subnetcalculator.html
cidr_block = "10.240.0.0/16"

public_cidr_block = "10.240.0.0/20"

private_cidr_block = "10.240.16.0/20"
