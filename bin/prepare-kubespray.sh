#!/bin/bash

set -euo pipefail

# https://github.com/cxhercules/demo-k8s-kubespray-gcp/blob/master/scripts/kubespray.sh
# https://github.com/cxhercules/demo-k8s-kubespray-gcp/tree/master/k8s-impl/tmpl-public-net
# : $REGION

: $TF_STATE_BUCKET
: $PROJECT_ID



# export TF_VAR_region=${REGION}
export TF_VAR_state_bucket=${TF_STATE_BUCKET}
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_private_ssh_path="${PWD}/states/cust_id_tfm_rsa"

MODULE="${PWD}/terraform/gce/infrastructure"

STATE="${PWD}/states/terraform.tfstate"
REMOTE_STATE_PREFIX="gce/infrastructure"

${TF_STATE_BUCKET}
${REMOTE_STATE_PREFIX}

gsutil cp gs://my-bucket/*.txt .

