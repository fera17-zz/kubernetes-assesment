#!/bin/bash

set -euo pipefail

: $TF_STATE_BUCKET
: $PROJECT_ID

PROJECT=terraform/gcp/dev

COMMAND=${1:-plan}

# export TF_VAR_region=${REGION}
export TF_VAR_state_bucket=${TF_STATE_BUCKET}
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_private_ssh_path="${PWD}/data/cust_id_rsa"

MODULE="${PWD}/terraform/gce/infrastructure"

STATE="${PWD}/states/terraform.tfstate"
REMOTE_STATE_PREFIX="gce/infrastructure"

terraform init \
-backend-config="bucket=${TF_STATE_BUCKET}" \
-backend-config="prefix=${REMOTE_STATE_PREFIX}" \
-backend=true -get=true -force-copy \
-reconfigure $MODULE

terraform ${COMMAND} \
-refresh=true \
-var-file="${PWD}/data/gce-infrastructure.tfvars" \
$MODULE
# | landscape

chmod 400 ${TF_VAR_private_ssh_path}
if [[ "$OSTYPE" == "darwin"* ]]; then
  ssh-add -D
  ssh-add -K ${TF_VAR_private_ssh_path}
else
  ssh-add -D
  ssh-add ${TF_VAR_private_ssh_path}
fi

gcloud compute instance-groups managed list

gcloud compute instances list

