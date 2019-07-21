variable name {}
variable region {}
variable project {}

variable tags {
  description = "Tag added to instances for firewall and networking."
  type        = "list"
}

variable instance_labels {
  description = "Labels added to instances."
  type        = "map"
}

variable distribution_policy_zones {
  description = "The distribution policy for this managed instance group when zonal=false. Default is all zones in given region."
  type        = "list"
  default     = []
}

variable disk_type {
  description = "The GCE disk type. Can be either pd-ssd, local-ssd, or pd-standard."
  default     = "pd-ssd"
}

variable disk_size_gb {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  default     = 50
}

variable mode {
  description = "The mode in which to attach this disk, either READ_WRITE or READ_ONLY."
  default     = "READ_WRITE"
}

variable disk_auto_delete {
  description = "Whether or not the disk should be auto-deleted."
  default     = true
}

variable preemptible {
  description = "Use preemptible instances - lower price but short-lived instances. See https://cloud.google.com/compute/docs/instances/preemptible for more details"
  default     = "false"
}

variable service_account_scopes {
  description = "List of scopes for the instance template service account"
  type        = "list"

  default = [
    "compute-rw",
    "storage-ro",
    "service-management",
    "service-control",
    "logging-write",
    "monitoring",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append",
  ]
}

variable can_ip_forward {
  description = "Allow ip forwarding."
  default     = false
}

variable machine_type {
  description = "Machine type for the VMs in the instance group."
  default     = "f1-micro"
}

variable compute_image {
  description = "Image used for compute VMs."
}

variable instance_subnetwork {
  description = "The subnetwork where to deploy instances"
}

variable access_config {
  description = "The access config block for the instances. Set to [] to remove external IP or [{}] to add external IP"
  type        = "list"

  default = []
}

variable metadata {
  description = "Map of metadata values to pass to instances."
  type        = "map"
  default     = {}
}

variable update_strategy {
  description = "The strategy to apply when the instance template changes."
  default     = "NONE"
}

variable replicas {
  description = "Number of replicas"
}

variable wait_for_instances {
  description = "Wait for all instances to be created/updated before returning"
  default     = false
}

variable target_pools {
  description = "The target load balancing pools to assign this group to."
  type        = "list"
  default     = []
}

variable service_port {
	default = 80
}
variable service_port_name {
	default = "default"
}

