data template_file cloud_init {
  template = "${file("${path.module}/templates/cloud-init.yaml")}"

  vars {
    user = "k8s"
  }
}

data template_cloudinit_config cloud_init {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud_init.rendered}"
  }
}

data template_file bastion_cloud_init {
  template = "${file("${path.module}/templates/bastion-cloud-init.yaml")}"
}

data template_cloudinit_config bastion_cloud_init {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.bastion_cloud_init.rendered}"
  }
}
