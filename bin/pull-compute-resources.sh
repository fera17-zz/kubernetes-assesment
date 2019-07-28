#!/bin/bash

set -euo pipefail

: $PROJECT_ID
: $PREFIX

# TODO: public ip for bbastion
bastion_ip=$(gcloud compute instances list --filter="${PREFIX}-bastion" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//")
master_ips=$(gcloud compute instances list --filter="${PREFIX}-master" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//")
worker_ips=$(gcloud compute instances list --filter="${PREFIX}-worker" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//")
etcd_ips=$(gcloud compute instances list --filter="${PREFIX}-etcd" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//")
loadbalancer_ip=$(gcloud compute addresses list --filter="${PREFIX}-masters-lb" --format=json | jq -r '.[].address' | tr "\n" " " | sed -e "s/ \{1,\}$//")

cat > "./data/resources" <<EOF
BASTION_IP="${bastion_ip}"
MASTER_IPS="${master_ips}"
WORKER_IPS="${worker_ips}"
ETCD_IPS="${etcd_ips}"
LB_IP="${loadbalancer_ip}"
ANSIBLE_USER="k8s"
EOF




