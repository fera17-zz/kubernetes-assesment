.EXPORT_ALL_VARIABLES:

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ssh-tunnel: ## create ssh tunnel
	@bin/sshtunnel.sh

gce-instances: ## list GCE instances
	@gcloud compute instances list

gce-infra: ## Setup GCE infrastructure
	@bin/terraform-infra.sh