environment = "dev"

ssh_user = "k8s"

region = "europe-west2"

project = "stakxlv0"

prefix = "k8s"

master_size = 3

worker_size = 2

etcd_size = 3

jumpbox_create = true

jumpbox_type = "f1-micro"

master_type = "g1-small"

worker_type = "g1-smal"

etcd_type = "f1-micro"

# find it with data
owner = "ivanka"

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

# https://www.site24x7.com/tools/ipv4-subnetcalculator.html
# The 10.200.0.0/20 IP address range can host up to 1024 compute instances.
cidr_block = "10.240.0.0/16"

public_cidr_block = "10.240.0.0/20"

private_cidr_block = "10.240.16.0/20"

pod_cidr = "192.168.0.0/16"

service_cidr = "10.96.0.0/12"

cluster_internal_domain = "cluster.local"

cni_version = "0.7.5"

calico_version = "v3.5"

pod_network_type = "calico"

