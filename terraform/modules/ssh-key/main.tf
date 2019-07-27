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

#############
# RESOURCES #
#############

resource tls_private_key this {
  algorithm = "${var.algorithm}"
  rsa_bits  = "${var.rsa_bits}"
}

resource local_file private_key {
  sensitive_content = "${tls_private_key.this.private_key_pem}"
  filename          = "${var.private_ssh_path}"
}

resource local_file public_rsa {
  sensitive_content = "${tls_private_key.this.public_key_openssh}"
  filename          = "${var.private_ssh_path}.pub"
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
