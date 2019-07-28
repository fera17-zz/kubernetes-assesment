.EXPORT_ALL_VARIABLES:

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

devsetup: ## DEV machine setup
	@pip3 install -r requirements.txt

ssh-tunnel: ## create ssh tunnel
	@bin/sshtunnel.sh

list-gce: ## list GCE resoruces
	@gcloud compute instances list

infra-create-gce: ## Task '2.1' > Setup GCE infrastructure for K8s cluster
	@bin/terraform-infra.sh apply

cluster-gce: ## Task '2.2' Provision kubernetes cluster for GCE with 'kubespray'
	@bin/cluster-deploy-cfg.sh gce

cluster-provision: ## Task '3.1' Provision Jenkins on kubernetes
	@bin/terraform-k8s.provision.sh apply

infra-teardown-gce: ## Task '13' > Tear down cluster with GCE infrastructure
	@bin/terraform-infra.sh destroy

ssh-bastion: ## Test ssh to bastion
	@ssh-add -D -K states/cust_id_tfm_rsa
	@ssh -o 'ForwardAgent yes' -o "StrictHostKeyChecking=no" -i states/cust_id_tfm_rsa k8s@35.189.105.90 -A

up: ## Create local development Vagrant box
	@vagrant up

stop: ## Stoplocal development Vagrant box
	@vagrant halt

destroy: ## Destroy local development Vagrant box
	@vagrant destroy --force

validate: ## Validate pre commit
	@pre-commit run --all-files