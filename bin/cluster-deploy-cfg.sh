#!/bin/bash

set -euo pipefail

: $TF_STATE_BUCKET
: $PROJECT_ID

PREFIX=k8s
PROVIDER=${1}

kubespray_version=${kubespray_versionx:-v2.10.4}

./bin/pull-compute-resources.sh

set +a
source ./data/resources
set -a

ansible_user="k8s"
echo -e "Bastion > \t\t $BASTION_IP"
echo -e "Master > \t\t $MASTER_IPS"
echo -e "Worker > \t\t $WORKER_IPS"
echo -e "ETCD > \t\t\t $ETCD_IPS"
echo -e "Load Balancer > \t $LB_IP"
echo -e "Ansible User > \t\t $ANSIBLE_USER"

current=$(pwd)
eval "$(ssh-agent)"

if [[ "$OSTYPE" == "darwin"* ]]; then
  ssh-add -D
  ssh-add -K ${current}/data/cust_id_rsa
else
  ssh-add -D
  ssh-add ${current}/data/cust_id_rsa
fi

git submodule update --init
run_version=$$--"${PROJECT_ID}"
echo "Run VErsion: $run_version"

pushd kubespray
{
  cp -rfp inventory/sample inventory/${run_version}

  jq -n --arg masters "$MASTER_IPS" --arg nodes "$WORKER_IPS" --arg etcds "$ETCD_IPS" --arg bastion_ip "$BASTION_IP" \
    --arg ansible_user "$ANSIBLE_USER" \
    '{ "masters":  ($masters|split(" ")), "nodes":  ($nodes|split(" ")), "etcds":  ($etcds|split(" ")), "bastion_ip": $bastion_ip, "ansible_user": $ansible_user  }' | \
    jinja2 ${current}/templates/hosts.ini.jinja2 > inventory/${run_version}/hosts.ini

  cp inventory/${run_version}/hosts.ini ${current}/data/hosts.ini.latest

  jq -n --arg lb_ip "$LB_IP" '{ "lb_ip": $lb_ip  }' | \
    jinja2 ${current}/templates/group_vars/all.yml.jinja2 > inventory/${run_version}/group_vars/all/all.yml
  jq -n --arg lb_ip "$LB_IP" '{ "lb_ip": $lb_ip  }' | \
    jinja2 ${current}/templates/group_vars/k8s-cluster.yml.jinja2 > inventory/${run_version}/group_vars/k8s-cluster/k8s-cluster.yml

  jq -n --arg masters "$MASTER_IPS" --arg nodes "$WORKER_IPS" --arg etcds "$ETCD_IPS" --arg bastion_ip "$BASTION_IP" \
    --arg ansible_user "$ANSIBLE_USER" \
    '{ "masters":  ($masters|split(" ")), "nodes":  ($nodes|split(" ")), "etcds":  ($etcds|split(" ")), "bastion_ip": $bastion_ip, "ansible_user": $ansible_user  }' | \
    jinja2 ${current}/templates/ssh-bastion.conf.jinja2 > ssh-bastion.custom.conf
  # copy for testing purpose
  cp ssh-bastion.custom.conf ~/.ssh/config
  cp ${current}/templates/addons.yml inventory/${run_version}/group_vars/k8s-cluster/addons.yml
  cp ${current}/templates/ansible.cfg ansible.cfg
  cp ${current}/templates/etcd.yml inventory/${run_version}/group_vars/etcd.yml
}

on_exit() {
  # tree inventory/${run_version}
  rm -rf kubespray/inventory/${run_version}
  ls -la inventory
}
trap on_exit EXIT

# test priveledge escalation
ansible -i inventory/${run_version}/hosts.ini -m ping all -f 20 -b

ansible-playbook -i inventory/${run_version}/hosts.ini cluster.yml -f 30 -b --become-user=root --flush-cache

popd
echo -e "Success for Version: $run_version. \n Copy kube config file into 'data' folder..."
echo "Setting up your KUBECONFIG"
echo "export KUBECONFIG=$(pwd)/data/admin.conf"
cp kubespray/inventory/${run_version}/artifacts/admin.conf data/admin.conf
