#!/bin/bash

set -euo pipefail

# https://github.com/cxhercules/demo-k8s-kubespray-gcp/blob/master/scripts/kubespray.sh
# https://github.com/cxhercules/demo-k8s-kubespray-gcp/tree/master/k8s-impl/tmpl-public-net
# : $REGION

: $TF_STATE_BUCKET
: $PROJECT_ID

PREFIX=k8s

export TF_VAR_state_bucket=${TF_STATE_BUCKET}
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_private_ssh_path="${PWD}/states/cust_id_tfm_rsa"

MODULE="${PWD}/terraform/gce/infrastructure"

REMOTE_STATE_PREFIX="gce/infrastructure"
STEP_STATE="data/gce-infrastructure.tfstate"
kubespray_version=${kubespray_versionx:-v2.5.0}

# if test -f "${STEP_STATE}"; then
# echo "file exist"
# else
#   gsutil cp gs://${TF_STATE_BUCKET}/${REMOTE_STATE_PREFIX}/default.tfstate data/${STEP_STATE}
# fi

bastion_ip=$(gcloud compute instances list --filter="${PREFIX}-bastion" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//")
master_ips=$(gcloud compute instances list --filter="${PREFIX}-master" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//")

echo $bastion_ip
echo $master_ips