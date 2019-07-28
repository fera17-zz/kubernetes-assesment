#!/bin/bash

{
  kubectl run nginx --image=nginx --replicas=1
  kubectl get pods
  kubectl delete deploy nginx
}

