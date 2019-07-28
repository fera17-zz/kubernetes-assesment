# ------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# ------------------------------------------------------------

variable region {
  description = "region for cloud resources"
}

variable project {
  description = "the project to deploy to, if not set the default provider project is used"
}

variable prefix {
  description = "a unique name beginning with the specified prefix"
}

variable zone {
  description = "The zone to create the bastion host in. Must be within the subnetwork region."
}

variable machine_type {
  description = "The machine type to create."
}

variable image {
  description = "The image from which to initialize this disk. This can be one of"
}

variable create {}

variable cidr_block {
  description = "The IP CIDR range represented by this alias IP range."
}

variable network {
  description = "Name of the network to deploy instances to."
}

variable subnetwork {
  description = "The subnetwork to deploy to"
}

# -------------------------------------------------
# OPTIONAL PARAMETERS
# Generally, these values won't need to be changed.
# -------------------------------------------------

variable labels {
  description = "A set of key/value label pairs to assign to the instance."
  type        = "map"
  default     = {}
}

variable tags {
  description = "The GCP network tag to apply to the bastion host for firewall rules. Defaults to 'public', the expected public tag of this module."
  type        = "string"
  default     = ["bastion"]
}

variable admin_whitelist {
  description = "list of ips to allow traffic from"
  type        = "list"
}

variable metadata {
  description = "Metadata key/value pairs to make available from within the instance."
  type        = "map"
  default     = {}
}
