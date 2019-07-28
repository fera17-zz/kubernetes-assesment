# Bastion Host Module

The Bastion Host module is used to configure a Google Compute Engine (GCE) VM Instance as a bastion host or "jumpbox", allowing access to private instances inside your VPC network.

Bastion hosts configured with this module are set up so access to the bastion host is controlled by the user's Google identity and the GCP IAM roles it's been granted through OS Login. SSH keys for individual instances are unable to be managed by the user; instead, GCP manages access through fine-grained, revokable IAM roles. OS Login is the recommended way to manage many users across multiple instances or projects on GCP.

## How do I SSH to the host?

Create an ssh config file

`ssh-jump.conf`
```
Host bastion
  Hostname 35.212.18.126
  StrictHostKeyChecking no
  ControlMaster auto
  ControlPersist 5m

Host  10.198.16.24
  ProxyCommand ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p k8s@bastion
```

Run a command

```
ssh k8s@10.240.16.24 -F ssh-jump.conf
```

It should SSH you to the desired host.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin\_whitelist | list of ips to allow traffic from | list | n/a | yes |
| cidr\_block | The IP CIDR range represented by this alias IP range. | string | n/a | yes |
| create |  | string | n/a | yes |
| image | The image from which to initialize this disk. This can be one of | string | n/a | yes |
| labels | A set of key/value label pairs to assign to the instance. | map | `{}` | no |
| machine\_type | The machine type to create. | string | n/a | yes |
| metadata | Metadata key/value pairs to make available from within the instance. | map | `{}` | no |
| network | Name of the network to deploy instances to. | string | n/a | yes |
| prefix | a unique name beginning with the specified prefix | string | n/a | yes |
| project | the project to deploy to, if not set the default provider project is used | string | n/a | yes |
| region | region for cloud resources | string | n/a | yes |
| subnetwork | The subnetwork to deploy to | string | n/a | yes |
| tags | The GCP network tag to apply to the bastion host for firewall rules. Defaults to 'public', the expected public tag of this module. | string | `[ "bastion" ]` | no |
| zone | The zone to create the bastion host in. Must be within the subnetwork region. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| external\_ip | The public IP of the bastion host. |
| internal\_ip | The internal IP of the bastion host. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->