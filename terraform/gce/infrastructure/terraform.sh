#!/bin/bash
# https://github.com/cxhercules/demo-k8s-kubespray-gcp/blob/master/scripts/kubespray.sh
set -euo pipefail
# https://github.com/cxhercules/demo-k8s-kubespray-gcp/tree/master/k8s-impl/tmpl-public-net
# : $REGION
: $TF_STATE_BUCKET
: $PROJECT_ID

PROJECT=terraform/gcp/dev

# export TF_VAR_region=${REGION}
export TF_VAR_state_bucket=${TF_STATE_BUCKET}
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_private_ssh_path="${PWD}/cust_id_tfm_rsa"
MODULE="terraform/test-folder/"

STATE="test-base.tfstate"

#  Generate a key

# ssh-keygen -t rsa -b 2048 -f cust_id_rsa -q -N ""

MODULE=tform

terraform init \
-backend-config="bucket=stakxlv0-tf-states" \
-backend-config="prefix=kubespray" \
-backend=true -get=true -force-copy \
-reconfigure $MODULE

# terraform plan \
# -refresh=true \
# -var-file="$MODULE/terraform.tfvars" \
# $MODULE | landscape

terraform apply \
-refresh=true \
-var-file="$MODULE/terraform.tfvars" \
$MODULE

# terraform destroy \
# -refresh=true \
# -var-file="$MODULE/terraform.tfvars" \
# $MODULE

# gcloud compute instances list
# gcloud compute ssh k8s-jumpbox --zone europe-west2-a
# ssh -i cust_id_tfm_rsa k8s@35.189.105.9

gcloud compute instances list