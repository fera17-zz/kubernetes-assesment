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
loadbalancer_ip="34.95.69.162"
master_ips="10.240.16.14 10.240.16.16 10.240.16.17"
worker_ips="10.240.16.15 10.240.16.13"
etcd_ips="10.240.16.22 10.240.16.23 10.240.16.24"
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

if [[ "$OSTYPE" == "darwin"* ]]; then
  ssh-add -D
  ssh-add -K ${current}/data/cust_id_rsa
else
  ssh-add -D
  ssh-add ${current}/data/cust_id_rsa
  ssh-add -L
fi


git submodule update --init
# cd kubespray && git checkout ${kubespray_version}

run_version=$$
echo "Run VErsion: $run_version"

cd kubespray
{
cp -rfp inventory/sample inventory/${run_version}

jq -n --arg masters "$master_ips" --arg nodes "$worker_ips" --arg etcds "$etcd_ips" --arg bastion_ip "$bastion_ip" \
  --arg ansible_user "$ansible_user" \
  '{ "masters":  ($masters|split(" ")), "nodes":  ($nodes|split(" ")), "etcds":  ($etcds|split(" ")), "bastion_ip": $bastion_ip, "ansible_user": $ansible_user  }' | \
  jinja2 ${current}/templates/hosts.ini.jinja2 > inventory/${run_version}/hosts.ini

cp inventory/${run_version}/hosts.ini ${current}/hosts.ini

jq -n --arg lb_ip "$loadbalancer_ip" '{ "lb_ip": $lb_ip  }' | \
  jinja2 ${current}/templates/group_vars/all.yml.jinja2 > inventory/${run_version}/group_vars/all/all.yml
jq -n --arg lb_ip "$loadbalancer_ip" '{ "lb_ip": $lb_ip  }' | \
  jinja2 ${current}/templates/group_vars/k8s-cluster.yml.jinja2 > inventory/${run_version}/group_vars/k8s-cluster/k8s-cluster.yml

jq -n --arg masters "$master_ips" --arg nodes "$worker_ips" --arg etcds "$etcd_ips" --arg bastion_ip "$bastion_ip" \
  --arg ansible_user "$ansible_user" \
  '{ "masters":  ($masters|split(" ")), "nodes":  ($nodes|split(" ")), "etcds":  ($etcds|split(" ")), "bastion_ip": $bastion_ip, "ansible_user": $ansible_user  }' | \
  jinja2 ${current}/templates/ssh-bastion.conf.jinja2 > ssh-bastion.custom.conf
  # copy for testing purpose
cp ssh-bastion.custom.conf ~/.ssh/config
cp ${current}/templates/addons.yml inventory/${run_version}/group_vars/k8s-cluster/addons.yml
cp ${current}/templates/ansible.cfg ansible.cfg
cp ${current}/templates/etcd.yml inventory/${run_version}/group_vars/etcd.yml
}


on_exit() {
  # gcloud compute instances list
  # cat inventory/${run_version}/hosts.ini
  rm -rf inventory/${run_version}
  ls -la inventory
}
trap on_exit EXIT

# test priveledge escalation
ansible -i inventory/${run_version}/hosts.ini -m ping all -vvv -f 20 -b

# sudo ansible-playbook -i inventory/${run_version}/hosts.ini cluster.yml -f 30 --flush-cache
# -e cloud_provider=gce -b --flush-cache


# -e ansible_user=k8s \
# -e ansible_ssh_user=k8s -vvv

# -b --become-user=k8s \
# -e ansible_ssh_user=k8s -e cloud_provider=gce -e ansible_become=yes -vv
  # --flush-cache -e ansible_user=k8s -f 20 -v -e ansible_become=yes \
  # -e ansible_ssh_user=k8s -e cloud_provider=gce -b --become-user=root


# https://github.com/cxhercules/demo-k8s-kubespray-gcp


# "ETCD_DATA_DIR=/var/lib/etcd",
#                 "ETCD_ADVERTISE_CLIENT_URLS=https://10.240.16.10:2379",
#                 "ETCD_INITIAL_ADVERTISE_PEER_URLS=https://10.240.16.10:2380",
#                 "ETCD_INITIAL_CLUSTER_STATE=new",
#                 "ETCD_METRICS=basic",
#                 "ETCD_LISTEN_CLIENT_URLS=https://10.240.16.10:2379,https://127.0.0.1:2379",
#                 "ETCD_ELECTION_TIMEOUT=5000",
#                 "ETCD_HEARTBEAT_INTERVAL=250",
#                 "ETCD_INITIAL_CLUSTER_TOKEN=k8s_etcd",
#                 "ETCD_LISTEN_PEER_URLS=https://10.240.16.10:2380",
#                 "ETCD_NAME=etcd1",
#                 "ETCD_PROXY=off",
#                 "ETCD_INITIAL_CLUSTER=etcd1=https://10.240.16.10:2380,etcd2=https://10.240.16.9:2380,etcd3=https://10.240.16.9:2380",
#                 "ETCD_AUTO_COMPACTION_RETENTION=8",
#                 "ETCD_SNAPSHOT_COUNT=10000",
#                 "ETCD_TRUSTED_CA_FILE=/etc/ssl/etcd/ssl/ca.pem",
#                 "ETCD_CERT_FILE=/etc/ssl/etcd/ssl/member-master1.pem",
#                 "ETCD_KEY_FILE=/etc/ssl/etcd/ssl/member-master1-key.pem",
#                 "ETCD_CLIENT_CERT_AUTH=true",
#                 "ETCD_PEER_TRUSTED_CA_FILE=/etc/ssl/etcd/ssl/ca.pem",
#                 "ETCD_PEER_CERT_FILE=/etc/ssl/etcd/ssl/member-master1.pem",
#                 "ETCD_PEER_KEY_FILE=/etc/ssl/etcd/ssl/member-master1-key.pem",
#                 "ETCD_PEER_CLIENT_CERT_AUTH=True",
#                 "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# etcdctl --endpoints https://127.0.0.1:2379 --ca-file=/etc/ssl/etcd/ssl/ca.pem --cert-file=/etc/ssl/etcd/ssl/member-master1.pem --key-file=/etc/ssl/etcd/ssl/member-master1-key.pem --debug cluster-healt