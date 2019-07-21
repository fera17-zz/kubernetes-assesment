#!/bin/bash

set -euo pipefail

# TEST whether or not node is able to work with Docker & Kubernetes

if [[ which docker && docker --version ]]; then
  # should run it
  docker run --rm hello-world > /tmp/hello-world.log
  # Should have nameservers & kubernetes entries
  docker run --rm alpine cat /etc/resolv.conf > /tmp/alpine-cat.log
  # Should be 0$ packet loss
  docker run --rm alpine ping -c1 8.8.8.8 > /tmp/alpine-pint.log
  # I can access lb port
  docker run --rm busybox nc ${load_balancer_ip} 6443 -v > /tmp/alb-access.log

  # docker info |grep -i cgroup
else
  echo "Install docker. Not installed"
fi


# should have open there!!
# Check ${load_balancer_ip}:6443 is accessible with cert!!

# check taints
# node(s) had taints that the pod didn't tolerate.

