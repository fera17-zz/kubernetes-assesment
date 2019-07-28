# Kuberentes at Master

<!-- START makefile-doc -->
```
$ make help 
devsetup                       DEV machine setup
ssh-tunnel                     create ssh tunnel
list-gce                       list GCE resoruces
infra-create-gce               Task '2.1' > Setup GCE infrastructure for K8s cluster
cluster-gce                    Task '2.2' Provision kubernetes cluster for GCE with 'kubespray'
infra-teardown-gce             Task '13' > Tear down cluster with GCE infrastructure
ssh-bastion                    Test ssh to bastion
up                             Create local development Vagrant box
stop                           Stoplocal development Vagrant box
destroy                        Destroy local development Vagrant box
validate                       Validate pre commit 
```
<!-- END makefile-doc -->

## Prerequisits

- [Docker](https://www.docker.com/why-docker)
- [Vagrant](https://www.vagrantup.com/)

## Project structure

## Setup Development Workspace



dependecies

python3 -m pip install --user virtualenv
pip3 install -r requirements.txt --user
pip3 uninstall -r requirements.txt -y --user
python
brew

```
python3 -m venv env
source env/bin/activate
export PATH="/Users/ivankatliarchuk/Library/Python/3.7/lib/python/site-packages:$PATH"
pip3 install jinja2-cli
```

SSH
UseDNS no
ClientAliveInterval 120
Subsystem       sftp    /usr/lib/openssh/sftp-server
AcceptEnv LANG LC_*
AllowAgentForwarding yes
https://www.digitalocean.com/community/tutorials/how-to-use-cloud-config-for-your-initial-server-setup
service ssh restart


PubkeyAuthentication yes
PasswordAuthentication no
ChallengeResponseAuthentication no


/etc/ssh/sshd_config




  docs
  https://www.vagrantup.com/docs/provisioning/file.html
