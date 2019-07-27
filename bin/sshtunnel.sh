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

ssh -vv -o 'ForwardAgent yes' -o "StrictHostKeyChecking=no" -i data/cust_id_tfm_rsa k8s@35.189.105.90 -A ssh -T k8s@10.240.0.23 -t -t

# ssh -o 'ForwardAgent yes' -o ControlMaster=auto -o ControlPersist=30m -o ConnectionAttempts=3 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o 'User="k8s"' 10.240.0.23 -i data/cust_id_tfm_rsa -o ConnectTimeout=20 -tt

hot wo ssh tunnel
https://medium.com/@0d6e/creating-an-ssh-bastion-host-in-google-cloud-vpc-86d65509eb42

ssh -vv -o 'ForwardAgent yes' -o "StrictHostKeyChecking=no"

ssh -i data/cust_id_rsa k8s@35.246.4.171 -A ssh -T k8s@10.240.16.2 -t -t

ssh -o UserKnownHostsFile=/dev/null admin@35.242.161.122 -A