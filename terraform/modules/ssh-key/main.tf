#############
# VARIABLES #
#############

variable algorithm {
  default = "RSA"
}

variable rsa_bits {
  default = "2048"
}

variable private_ssh_path {}
variable private_ssh_key {}

#############
# RESOURCES #
#############

resource tls_private_key this {
  algorithm = "${var.algorithm}"
  rsa_bits  = "${var.rsa_bits}"
}

resource local_file private_ssh {
  sensitive_content = "${var.private_ssh_key}"
  filename          = "${var.private_ssh_path}"
}

###########
# OUTPUTS #
###########
output public {
  value     = "${tls_private_key.this.public_key_openssh}"
  sensitive = true
}

output private {
  value     = "${tls_private_key.this.private_key_pem}"
  sensitive = true
}

output fingerprint {
  value     = "${tls_private_key.this.public_key_fingerprint_md5}"
  sensitive = true
}
