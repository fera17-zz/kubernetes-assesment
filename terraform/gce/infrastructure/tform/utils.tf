# SSH KEYS
module ssh_key {
  source = "../../../tf-modules/ssh-key"
}

module utils {
  source = "../../../tf-modules/utils"

  private_ssh_path = "${var.private_ssh_path}"
  private_ssh_key  = "${module.ssh_key.private}"
}
