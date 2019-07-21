https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
https://github.com/nikhilkoduri-searce/terraform-k8s-gce


SSH
https://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/


# Check startup script
sudo journalctl -u google-startup-scripts.service

run script
```
sudo google_metadata_script_runner --script-type startup --debug
/var/log/cloud-init.log

cloud-init analyze show -i my-cloud-init.log
```

```
cat /var/log/cloud-final.err
cat /var/log/cloud-final.out
cloud-init analyze show -i /var/log/cloud-final.out
cat /var/log/cloud-init-output.log
cat /var/log/cloud-init.err
cat /var/log/cloud-init.log
cat /var/log/cloud-init.out
cloud-init analyze show -i /var/log/cloud-init-output.log
```


Cool adm setup
https://github.com/jpweber/kubeadm-terraform/blob/master/control_plane.tpl

Verificatrion of kubernetes

10.240.0.0/24,10.200.0.0/16

Create HA and Canico and CNI etc
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/


Kopy file from remote
provisioner "local-exec" {
  command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.openstack_keypair} ubuntu@${openstack_networking_floatingip_v2.wr_manager_fip.address}:~/client.token ."
}

<!-- RetmoeExec -->
https://github.com/sdorsett/terraform-vsphere-kubernetes/tree/2018-12-26-post

<!-- kubespray -->
https://github.com/kubernetes-sigs/kubespray/issues/4121

<!-- Join cluster -->
https://github.com/stefanprodan/k8s-scw-baremetal

Kubeadm
https://github.com/jpweber/kubeadm-terraform
https://github.com/nikhilkoduri-searce/terraform-k8s-gce