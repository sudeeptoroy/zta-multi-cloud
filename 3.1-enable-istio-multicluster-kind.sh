#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will install Isio multi-cluster discovery                              #"
echo -e "########################################################################################"
read -p "Press any key to begin"

# Cluster 1
istioctl x create-remote-secret --context="${CLUSTER1}" --name=cluster1  --server=https://aws-cluster-control-plane:6443 | kubectl apply -f - --context="${CLUSTER2}"
istioctl x create-remote-secret --context="${CLUSTER1}" --name=cluster1  --server=https://aws-cluster-control-plane:6443 | kubectl apply -f - --context="${CLUSTER3}"

sleep 2

# Cluster 2
istioctl x create-remote-secret --context="${CLUSTER2}" --name=cluster2 --server=https://google-cluster-control-plane:6443 | kubectl apply -f - --context="${CLUSTER1}"
istioctl x create-remote-secret --context="${CLUSTER2}" --name=cluster2 --server=https://google-cluster-control-plane:6443 | kubectl apply -f - --context="${CLUSTER3}"

sleep 2

# Cluster 3
istioctl x create-remote-secret --context="${CLUSTER3}" --name=cluster3 --server=https://azure-cluster-control-plane:6443 | kubectl apply -f - --context="${CLUSTER1}"
istioctl x create-remote-secret --context="${CLUSTER3}" --name=cluster3 --server=https://azure-cluster-control-plane:6443 | kubectl apply -f - --context="${CLUSTER2}"
