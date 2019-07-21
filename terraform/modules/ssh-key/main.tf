#############
# VARIABLES #
#############

variable algorithm {
  default = "RSA"
}

variable rsa_bits {
  default = "2048"
}

#############
# RESOURCES #
#############

resource tls_private_key this {
  algorithm = "${var.algorithm}"
  rsa_bits  = "${var.rsa_bits}"
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
