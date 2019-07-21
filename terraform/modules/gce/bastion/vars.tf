variable pub_key {}
variable region {}
variable project {}
variable prefix {}
variable ssh_keys {}
variable zone {}
# variable internal_ip {}
variable type {}
variable image {}
variable create {}
variable cidr_block {}

variable network {
  default = "default"
}

variable subnetwork {
  default = "default"
}

variable labels {
  type    = "map"
  default = {}
}

variable admin_whitelist {
  type = "list"
}

variable metadata {
  type = "map"
  default = {}
}
