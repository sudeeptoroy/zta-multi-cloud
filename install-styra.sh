#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will install Styra DAS on  Isio multi-cluster                          #"
echo -e "########################################################################################"
read -p "Press any key to begin"

kubectl label ns kube-system openpolicyagent.org/webhook=ignore --context="${CLUSTER1}"
kubectl label ns kube-system openpolicyagent.org/webhook=ignore --context="${CLUSTER2}"

kubectl label ns kube-public openpolicyagent.org/webhook=ignore --context="${CLUSTER1}"
kubectl label ns kube-public openpolicyagent.org/webhook=ignore --context="${CLUSTER2}"

kubectl label ns kube-node-lease openpolicyagent.org/webhook=ignore --context="${CLUSTER1}"
kubectl label ns kube-node-lease openpolicyagent.org/webhook=ignore --context="${CLUSTER2}"

kubectl label ns istio-system openpolicyagent.org/webhook=ignore --context="${CLUSTER1}"
kubectl label ns istio-system openpolicyagent.org/webhook=ignore --context="${CLUSTER2}"

kubectl apply -f cluster1-styra.yaml -n styra-system --context="${CLUSTER1}"
kubectl apply -f cluster2-styra.yaml -n styra-system --context="${CLUSTER2}"