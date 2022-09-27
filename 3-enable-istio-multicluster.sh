#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will install Isio multi-cluster discovery                              #"
echo -e "########################################################################################"
read -p "Press any key to begin"

# Cluster 1
istioctl x create-remote-secret --context="${CLUSTER1}" --name=cluster1 | kubectl apply -f - --context="${CLUSTER2}"
istioctl x create-remote-secret --context="${CLUSTER1}" --name=cluster1 | kubectl apply -f - --context="${CLUSTER3}"


# Cluster 2
istioctl x create-remote-secret --context="${CLUSTER2}" --name=cluster2 | kubectl apply -f - --context="${CLUSTER1}"
istioctl x create-remote-secret --context="${CLUSTER2}" --name=cluster2 | kubectl apply -f - --context="${CLUSTER3}"

# Cluster 3
istioctl x create-remote-secret --context="${CLUSTER3}" --name=cluster3 | kubectl apply -f - --context="${CLUSTER1}"
istioctl x create-remote-secret --context="${CLUSTER3}" --name=cluster3 | kubectl apply -f - --context="${CLUSTER2}"
