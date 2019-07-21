# pub_key = "cust_id_rsa.pub" # path for a key to login to jumpbox

environment = "dev"

# api_key = "gcp-creds.json" # GCP credentials file

ssh_user = "k8s"

region = "europe-west2"

project = "stakxlv0"

prefix = "k8s"

master_group_size = 0

worker_group_size = 0

jumpbox_create = false

cluster_zones = ["europe-west2-a", "europe-west2-b", "europe-west2-c"]

jumpbox_create = false

jumpbox_type = "f1-micro"

master_type = "g1-small"

worker_type = "g1-smal"

# find it with data
owner = "ivanka"


access_config = []

update_strategy = "MIGRATE"

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

# The 10.100.0.0/16 IP address range can host up to 4096 compute instances.
secondary_cidr_block = "10.200.0.0/16"
secondary_public_cidr = "10.200.0.0/20"
secondary_private_cidr = "10.200.16.0/20"

pod_cidr = "192.168.0.0/16"
service_cidr = "10.96.0.0/12"
cluster_internal_domain = "cluster.local"

cni_version = "0.7.5"
calico_version = "v3.5"
pod_network_type = "calico"