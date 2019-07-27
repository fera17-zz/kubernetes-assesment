variable project {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable name {
	description = "name of the resource"
}

variable prefix {
	description = "prefix for the forwarding rule and prefix for supporting resources."
}

variable region {
  description = "Region for cloud resources."
  default     = "us-central1"
}

variable network {
  description = "Name of the network to create resources in."
  default     = "default"
}

variable firewall_project {
  description = "Name of the project to create the firewall rule in. Useful for shared VPC. Default is var.project."
  default     = ""
}


variable service_port {
  description = "TCP port your service is listening on."
}

variable service_port_name {
  description = "The port name that we associate with instance group and tell load balancer to send traffic"
}

variable session_affinity {
  description = "How to distribute load. Options are `NONE`, `CLIENT_IP` and `CLIENT_IP_PROTO`"
  default     = "NONE"
}

variable instance_group {
  description = "managed instance group"
}

variable admin_whitelist {
  type = "list"
}

variable nat_ips {
  type = "list"
}

variable cidr_block {}
# https://github.com/GoogleCloudPlatform/terraform-google-lb/blob/master/main.tf
