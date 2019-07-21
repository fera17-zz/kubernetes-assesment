data template_file cloud_init {
  template = "${file("${path.module}/templates/cloud-init.yaml")}"
}

data template_cloudinit_config cloud_init {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud_init.rendered}"
  }
}
