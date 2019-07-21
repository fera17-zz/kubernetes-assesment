#!/bin/bash

set -euo pipefail

# https://github.com/cxhercules/demo-k8s-kubespray-gcp/blob/master/scripts/kubespray.sh
# https://github.com/cxhercules/demo-k8s-kubespray-gcp/tree/master/k8s-impl/tmpl-public-net
# : $REGION

: $TF_STATE_BUCKET
: $PROJECT_ID

PROJECT=terraform/gcp/dev

# export TF_VAR_region=${REGION}
export TF_VAR_state_bucket=${TF_STATE_BUCKET}
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_private_ssh_path="${PWD}/data/cust_id_tfm_rsa"

MODULE="${PWD}/terraform/gce/infrastructure"

STATE="${PWD}/states/terraform.tfstate"
REMOTE_STATE_PREFIX="gce/infrastructure"

terraform init \
-backend-config="bucket=${TF_STATE_BUCKET}" \
-backend-config="prefix=${REMOTE_STATE_PREFIX}" \
-backend=true -get=true -force-copy \
-reconfigure $MODULE

# terraform init -get=true -force-copy \
# -reconfigure $MODULE

terraform apply \
-refresh=true \
-var-file="${PWD}/data/gce-infrastructure.tfvars" \
$MODULE | landscape

# -state="${STATE}" \

# terraform destroy \
# -refresh=true \
# -state="${STATE}" \
# -var-file="$MODULE/terraform.tfvars" \
# $MODULE

if test -f "$TF_VAR_private_ssh_path"; then
  ssh-add -D
  chmod 400 ${TF_VAR_private_ssh_path}
  ssh-add -K ${TF_VAR_private_ssh_path}
fi


# gcloud compute instances list
# gcloud compute ssh k8s-jumpbox --zone europe-west2-a
# ssh -i cust_id_tfm_rsa k8s@35.189.105.9

gcloud compute instances list
