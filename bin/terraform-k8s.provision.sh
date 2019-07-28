#!/bin/bash

set -euo pipefail

: $TF_STATE_BUCKET
: $PROJECT_ID

PROJECT=terraform/gcp/dev

COMMAND=${1:-plan}

export TF_VAR_region=${REGION}
export TF_VAR_state_bucket=${TF_STATE_BUCKET}
export TF_VAR_project=${PROJECT_ID}

MODULE="${PWD}/terraform/cluster/provision"

# STATE="${PWD}/states/terraform.tfstate"
REMOTE_STATE_PREFIX="gce/clusterprovision"

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



