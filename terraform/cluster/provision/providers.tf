terraform {
  backend "gcs" {}
}

provider kubernetes {
  version          = ">=1.8.1"
  load_config_file = true
  config_path      = "/vagrant/data/admin.conf" # Works ok
}

# provider helm {
#   version        = ">=0.9"
#   install_tiller = false


#   insecure     = false
#   enable_tls   = false
#   tiller_image = "${var.tiller_image}"


#   kubernetes {
#     host                   = "${data.aws_eks_cluster.this.endpoint}"
#     cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)}"
#     token                  = "${data.aws_eks_cluster_auth.this.token}"
#   }
# }

