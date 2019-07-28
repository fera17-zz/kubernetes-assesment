# Cluster Infrastructure

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| access\_config | Access configuration, i.e. IP via which instance can be accessed | list | `[]` | no |
| admin\_whitelist |  | list | n/a | yes |
| cidr\_block |  | string | n/a | yes |
| cluster\_zones |  | list | `[]` | no |
| environment |  | string | n/a | yes |
| etcd\_service\_port |  | string | n/a | yes |
| etcd\_size |  | string | n/a | yes |
| etcd\_type | The machine type to create for etcd | string | n/a | yes |
| jumpbox\_create | define whether or not jumpbox/bastion is created | string | n/a | yes |
| jumpbox\_type |  | string | n/a | yes |
| master\_service\_port |  | string | n/a | yes |
| master\_size |  | string | n/a | yes |
| master\_type | The machine type to create for controll plane | string | n/a | yes |
| prefix | a unique name beginning with the specified prefix | string | n/a | yes |
| private\_cidr\_block |  | string | n/a | yes |
| private\_ssh\_path |  | string | n/a | yes |
| project | the project to deploy to, if not set the default provider project is used | string | n/a | yes |
| public\_cidr\_block |  | string | n/a | yes |
| region | region for cloud resources | string | n/a | yes |
| service\_account\_scopes |  | list | `[]` | no |
| ssh\_user | The name of the default ssh user | string | n/a | yes |
| update\_strategy |  | string | n/a | yes |
| worker\_size |  | string | n/a | yes |
| worker\_type | The machine type to create for worker | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_external\_ip |  |
| bastion\_internal\_ip | bastion |
| cidr\_range | Networking |
| gcr\_location | cluster |
| load\_balancer\_external\_static\_ip |  |
| nat\_external\_static\_ip | TODO: inline return types |
| network |  |
| private\_ssh\_key |  |
| private\_ssh\_path |  |
| public\_ssh\_key |  |
| subnetwork |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Need to try
VMS,firewall, cloud init etc
https://github.com/nikhilkoduri-searce/terraform-k8s-gce

## TODO
https://github.com/nikhilkoduri-searce/terraform-k8s-gce/blob/master/terraform-master/main.tf

# Kubeadm how to
https://www.bogotobogo.com/DevOps/DevOps-Kubernetes-III-Kubernetes-on-Linux-with-kubeadm.php

## CNI and memory requierements
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# CNI
https://ifritltd.com/2019/06/16/automating-highly-available-kubernetes-cluster-and-external-etcd-setup-with-terraform-and-kubeadm-on-aws/

## HA
https://ifritltd.com/2019/06/16/automating-highly-available-kubernetes-cluster-and-external-etcd-setup-with-terraform-and-kubeadm-on-aws/



https://github.com/kenych/terraform_exs/blob/master/etcd/main.tf
https://ifritltd.com/2019/06/16/automating-highly-available-kubernetes-cluster-and-external-etcd-setup-with-terraform-and-kubeadm-on-aws/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/
https://velotio.com/blog/2018/6/15/kubernetes-high-availability-kubeadm


<!-- NODE LABELS -->
node-role.kubernetes.io/master:NoSchedule

<!-- CERTIFICATES -->
openssl s_client -connect image-review.dev.photostampsonline.com:443 > won.cert

depth=4 C = US, O = "Starfield Technologies, Inc.", OU = Starfield Class 2 Certification Authority
verify return:1
depth=3 C = US, ST = Arizona, L = Scottsdale, O = "Starfield Technologies, Inc.", CN = Starfield Services Root Certificate Authority - G2
verify return:1
depth=2 C = US, O = Amazon, CN = Amazon Root CA 1
verify return:1
depth=1 C = US, O = Amazon, OU = Server CA 1B, CN = Amazon
verify return:1
depth=0 CN = *.dev.photostampsonline.com

<!-- etcd -->
openssl s_client -connect 35.189.105.90:2379

subject=CN = k8s-master-06v3
issuer=CN = etcd-ca
Acceptable client certificate CA names
CN = etcd-ca
Client Certificate Types: RSA sign, ECDSA sign
Certificate chain
 0 s:CN = k8s-master-06v3
   i:CN = etcd-ca


openssl x509 -text -noout -in /etc/kubernetes/pki/etcd/server.crt
X509v3 Subject Alternative Name:
                DNS:k8s-master-06v3, DNS:localhost, IP Address:35.189.105.90, IP Address:127.0.0.1, IP Address:0:0:0:0:0:0:0:1
X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication, TLS Web Client Authenticatio
                Subject: CN = k8s-master-06v3
                Issuer: CN = etcd-ca


READY CLUSTER. USE IT
https://github.com/poseidon/typhoon/tree/master/google-cloud/container-linux/kubernetes ready kubo
https://github.com/poseidon/terraform-render-bootkube










https://github.com/andreyk-code/no-inet-gke-cluster/blob/master/priv-cluster/main.tf

Private DNS
https://github.com/BrownianMotionDrivenDevelopment/blog4_deployKafkaServerInTerraformManagedDomain/blob/master/kafka.tf



/var/lib/kubelet/config.yaml
/var/lib/kubelet/kubeadm-flags.env


kubeadm init --apiserver-cert-extra-sans=
--apiserver-advertise-address=0.0.0.0 --apiserver-cert-extra-sans=10.161.233.80,114.215.201.87
docker rm -f `docker ps -q -f 'name=k8s_kube-apiserver*'`
systemctl restart kubelet

--apiserver-bind-port

sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=0.0.0.0 \
--apiserver-cert-extra-sans=10.240.0.16,34.98.87.238 --service-dns-domain=cluster.local \
--service-cidr=10.96.0.0/12 --upload-certs
