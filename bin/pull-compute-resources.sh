#!/bin/bash

set -uo pipefail

: $PROJECT_ID
: $PREFIX

public_ip() {
    gcloud compute instances list --filter="${1}" --format=json | jq -r '.[].networkInterfaces[].accessConfigs[].natIP' | tr "\n" " " | sed -e "s/ \{1,\}$//"
}

private_ip() {
    gcloud compute instances list --filter="${1}" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//"
}

# TODO: public ip for bbastion
bastion_ip=$(public_ip "${PREFIX}-bastion")
master_ips=$(private_ip "${PREFIX}-master")
worker_ips=$(private_ip "${PREFIX}-worker")
etcd_ips=$(private_ip "${PREFIX}-etcd")
loadbalancer_ip=$(gcloud compute addresses list --filter="${PREFIX}-masters-lb" --format=json | jq -r '.[].address' | tr "\n" " " | sed -e "s/ \{1,\}$//")

cat > "./data/resources" <<EOF
BASTION_IP="${bastion_ip}"
MASTER_IPS="${master_ips}"
WORKER_IPS="${worker_ips}"
ETCD_IPS="${etcd_ips}"
LB_IP="${loadbalancer_ip}"
ANSIBLE_USER="k8s"
EOF
