variable region {}
variable project {}
variable prefix {}
variable jumpbox_create {}
variable jumpbox_type {}
variable master_type {}
variable master_size {}
variable worker_type {}
variable worker_size {}
variable etcd_type {}
variable etcd_size {}
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

variable cidr_block {}
variable public_cidr_block {}
variable private_cidr_block {}

