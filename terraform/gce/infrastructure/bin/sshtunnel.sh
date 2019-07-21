#!/bin/bash

# set -euo pipefail

JUMPBOX_HOST=$(terraform output bastion_ip 2>/dev/null)
JUMPBOX_PORT=22
REMOTE_HOST=10.240.0.5
REMOTE_PORT=22
LOCAL_PORT=9081
KEYFILE="cust_id_tfm_rsa"
USER="k8s"

cleanup() {
    kill $(ps -ef | awk "/ssh.*$LOCAL_PORT/ && ! /awk/ { print \$2 }")
}
trap cleanup EXIT

# make sure the key is read only
chmod 400 $KEYFILE
# delete all identities, add current key
ssh-add -D -K $KEYFILE
# ssh -L ${LOCAL_PORT}:${REMOTE_HOST}:${REMOTE_PORT} -fN $USER@$JUMPBOX_HOST -i $KEYFILE -tt

ssh -o 'ForwardAgent yes' -o "StrictHostKeyChecking=no" -i cust_id_tfm_rsa k8s@${JUMPBOX_HOST} -A ssh -T k8s@10.240.0.4 -tt
