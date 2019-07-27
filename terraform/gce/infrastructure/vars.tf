variable region {}
variable project {}
variable prefix {}
variable jumpbox_create {}
variable jumpbox_type {}
variable owner {}
variable master_type {}
variable master_group_size {}
variable worker_type {}
variable worker_group_size {}
variable update_strategy {}
variable environment {}
variable private_ssh_path {}
variable ssh_user {}

variable service_account_scopes {
  default = []
}

variable access_config {
  default = []
}

variable cluster_zones {
  default = []
}

variable jumpbox_internal_ip {}

variable admin_whitelist {
  type = "list"
}

variable master_service_port {}

# Firewalls https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

variable cidr_block {}
variable public_cidr_block {}
variable private_cidr_block {}

# master
variable cluster_internal_domain {}

variable cni_version {
  description = "The version of the kubernetes cni resources to install. See available versions using: `apt-cache madison kubernetes-cni`"
}

variable pod_cidr {
  description = "The CIDR for the pod network. The master will allocate a portion of this subnet for each node."

}

variable service_cidr {
  description = "The CIDR for the service network"
}

variable dns_ip {
  description = "The IP of the kube DNS service, must live within the service_cidr."
  default     = "10.96.0.10"
}

variable pod_network_type {
  description = "The type of networking to use for inter-pod traffic. Either kubenet or calico."
}

variable calico_version {
  description = "The calico version to be installed on cluster"
}