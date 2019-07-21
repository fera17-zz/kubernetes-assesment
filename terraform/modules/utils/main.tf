#############
# VARIABLES #
#############

variable private_ssh_path {}
variable private_ssh_key {}

resource local_file private_ssh {
  sensitive_content = "${var.private_ssh_key}"
  filename          = "${var.private_ssh_path}"
}
