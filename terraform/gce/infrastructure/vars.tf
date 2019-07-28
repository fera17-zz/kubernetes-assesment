variable region {
  description = "region for cloud resources"
}

variable project {
  description = "the project to deploy to, if not set the default provider project is used"
}

variable prefix {
  description = "a unique name beginning with the specified prefix"
}

variable jumpbox_create {
  description = "define whether or not jumpbox/bastion is created"
}

variable jumpbox_type {}

variable master_type {
  description = "The machine type to create for controll plane"
}

variable master_size {}

variable worker_type {
  description = "The machine type to create for worker"
}

variable worker_size {}

variable etcd_type {
  description = "The machine type to create for etcd"
}

variable etcd_size {}
variable environment {}
variable private_ssh_path {}

variable ssh_user {
  description = "The name of the default ssh user"
}

variable service_account_scopes {
  default = []
}

variable cluster_zones {
  default = []
}

variable admin_whitelist {
  type = "list"
}

variable master_service_port {}
variable etcd_service_port {}
variable cidr_block {}
variable public_cidr_block {}
variable private_cidr_block {}
