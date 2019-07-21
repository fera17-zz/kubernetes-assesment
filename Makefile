.EXPORT_ALL_VARIABLES:

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ssh-tunnel: ## create ssh tunnel
	@bin/sshtunnel.sh

gce-list: ## list GCE resoruces
	@gcloud compute instances list

gce-infra: ## Setup GCE infrastructure
	@bin/terraform-infra.sh

ssh-bastion: ## Test ssh to bastion
	@ssh-add -D -K states/cust_id_tfm_rsa
	@ssh -o 'ForwardAgent yes' -o "StrictHostKeyChecking=no" -i states/cust_id_tfm_rsa k8s@35.189.105.90 -A

gce-spray-prepare: ## Prepare kubespray
	@bin/prepare-kubespray-cfg.sh