# SSH KEYS
module ssh_key {
  source = "../../modules/ssh-key"
  private_ssh_path = "${var.private_ssh_path}"
  # private_ssh_key  = "${module.ssh_key.private}"
}
