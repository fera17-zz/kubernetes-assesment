# ------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# ------------------------------------------------------------
variable namespace {}

# -------------------------------------------------
# OPTIONAL PARAMETERS
# Generally, these values won't need to be changed.
# -------------------------------------------------

variable tiller_image {
  default = "gcr.io/kubernetes-helm/tiller:v2.14.2"
}
variable tiller_version {
  default = "v2.14.2"
}
variable tiller_replicas {
  default = 1
}

variable tiller_max_history {
  default = 50
}

variable tiller_service_type {
  type        = "string"
  default     = "ClusterIP"
  description = "Type of Tiller's Kubernetes service object."
}
