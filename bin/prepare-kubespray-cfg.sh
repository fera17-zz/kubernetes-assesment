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
kubespray_version=${kubespray_versionx:-v2.9.0}

# if test -f "${STEP_STATE}"; then
# echo "file exist"
# else
#   gsutil cp gs://${TF_STATE_BUCKET}/${REMOTE_STATE_PREFIX}/default.tfstate data/${STEP_STATE}
# fi
# TODO: public ip for bbastion
# bastion_ip=$(gcloud compute instances list --filter="${PREFIX}-bastion" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//")
# master_ips=$(gcloud compute instances list --filter="${PREFIX}-master" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//")
# worker_ips=$(gcloud compute instances list --filter="${PREFIX}-worker" --format=json | jq -r '.[].networkInterfaces[].networkIP' | tr "\n" " " | sed -e "s/ \{1,\}$//")
# loadbalancer_ip=$(gcloud compute addresses list --filter="${PREFIX}-masters-lb" --format=json | jq -r '.[].address' | tr "\n" " " | sed -e "s/ \{1,\}$//")

nat_master_ips=$(cat /dev/null)
nat_node_ips=$(cat /dev/null)

bastion_ip="35.246.4.171"
loadbalancer_ip="35.190.54.141"
master_ips="10.240.16.28 10.240.16.26 10.240.16.29"
worker_ips="10.240.16.30 10.240.16.31 10.240.16.27"
ansible_user="k8s"
echo -e "Bastion > \t\t $bastion_ip"
echo -e "Master > \t\t $master_ips"
echo -e "Worker > \t\t $worker_ips"
echo -e "Load Balancer > \t $loadbalancer_ip"

if [ ! -d inventory/group_vars ]; then
  mkdir -p inventory/group_vars
fi

current=$(pwd)
echo $current
eval "$(ssh-agent)"
ssh-add -D
ssh-add -K ${current}/data/cust_id_rsa

git submodule update --init
# cd kubespray && git checkout ${kubespray_version}

run_version=$$
echo "Run VErsion: $run_version"

cd kubespray
cp -rfp inventory/sample inventory/${run_version}
jq -n --arg masters "$master_ips" --arg nodes "$worker_ips" --arg bastion_ip "$bastion_ip" \
  --arg ansible_user "$ansible_user" \
  '{ "masters":  ($masters|split(" ")), "nodes":  ($nodes|split(" ")), "bastion_ip": $bastion_ip, "ansible_user": $ansible_user  }' | \
  jinja2 ${current}/templates/hosts.ini.jinja2 > inventory/${run_version}/hosts.ini

jq -n --arg lb_ip "$loadbalancer_ip" '{ "lb_ip": $lb_ip  }' | \
  jinja2 ${current}/templates/group_vars/all.yml.jinja2 > inventory/${run_version}/group_vars/all/all.yml
jq -n --arg lb_ip "$loadbalancer_ip" '{ "lb_ip": $lb_ip  }' | \
  jinja2 ${current}/templates/group_vars/k8s-cluster.yml.jinja2 > inventory/${run_version}/group_vars/k8s-cluster/k8s-cluster.yml

# cp inventory/${run_version}/group_vars/all/all.yml inventory/${run_version}/group_vars/all.yml
# cp inventory/${run_version}/group_vars/k8s-cluster/k8s-cluster.yml inventory/${run_version}/group_vars/k8s-cluster.yml
# git submodule update --init

on_exit() {
  # gcloud compute instances list
  cat inventory/${run_version}/hosts.ini
  rm -rf inventory/${run_version}
  ls -la inventory
}
trap on_exit EXIT

sudo ansible-playbook -i inventory/${run_version}/hosts.ini cluster.yml -f 30 -e ansible_user=k8s \
-e ansible_ssh_user=k8s -vvv
# -b --become-user=k8s \
# -e ansible_ssh_user=k8s -e cloud_provider=gce -e ansible_become=yes -vv
  # --flush-cache -e ansible_user=k8s -f 20 -v -e ansible_become=yes \
  # -e ansible_ssh_user=k8s -e cloud_provider=gce -b --become-user=root
# sudo ansible-playbook -i inventory/${run_version}/hosts.ini cluster.yml \
#   --flush-cache -v -e ansible_user=k8s -b --become-user=root -f 20 -vv



# https://github.com/cxhercules/demo-k8s-kubespray-gcp


# --private-key=${current}/data/cust_id_tfm_rsa \

# [all:vars]
# ansible_ssh_user=k8s
# ansible_user=k8s
# ansible_become=yes
# ansible_python_interpreter="/opt/bin/python3"

