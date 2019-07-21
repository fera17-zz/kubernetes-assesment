data template_file master_init {
  template = "${file("${path.module}/templates/control_plane.yaml")}"

  vars {
    k8s_version      = "1.15.1"
    docker_version   = "18.06"
    cluster_domain   = "${var.cluster_internal_domain}"
    network_plugin   = "cni"
    cni_version      = "${var.cni_version}"
    project          = "${var.project}"
    tags             = "${local.master_tags[0]}"
    instance_prefix  = "${var.prefix}"
    pod_network_type = "${var.pod_network_type}"
    dns_ip           = "10.96.0.10"
    network_name     = "${module.network.network_name}"
    subnetwork_name  = "${module.network.private_subnetwork_name}"
    elb_dns          = "todo"
    alb_port         = "6443"
    service_cidr     = "${var.service_cidr}"
    pod_cidr         = "${var.pod_cidr}"
  }
}

data template_file node_test {
  template = "${file("${path.module}/templates/node-test.sh")}"

  vars {
    load_balancer_ip = "toto" #${module.load_balancer.external_ip}"
    cluster_domain   = "${var.cluster_internal_domain}"
  }
}

data template_cloudinit_config master {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.master_init.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.node_test.rendered}"
  }
}

# https://cloudinit.readthedocs.io/en/latest/topics/format.html


# IP=$(curl -s -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip)


# EXTIP=35.189.105.90
# IP=$(curl -s -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip)
# kubeadm init --apiserver-advertise-address=${IP},${EXTIP}
# kubeadm init --apiserver-advertise-address=${IP},${EXTIP} --ignore-preflight-errors=NumCPU

