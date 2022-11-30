#!/bin/bash

set -e

echo -e "########################################################################################"
echo -e "#   This script will deploy 3 kind Clusters                                            #"
echo -e "########################################################################################"
read -p "Press any key to begin"

# bring up kind cluster 1
kind create cluster --config=kind/kind-aws.yaml

# bring up kind cluster 2
kind create cluster --config=kind/kind-google.yaml

# bring up kind cluster 3
kind create cluster --config=kind/kind-azure.yaml

export CTX_CLUSTER1=kind-aws-cluster
export CTX_CLUSTER2=kind-google-cluster
export CTX_CLUSTER3=kind-azure-cluster

# install LB for the east west gw
kubectl apply -f kind/metallb.yaml --context=$CTX_CLUSTER1
kubectl apply -f kind/metallb.yaml --context=$CTX_CLUSTER2
kubectl apply -f kind/metallb.yaml --context=$CTX_CLUSTER3

#In order to complete the configuration, we need to provide a range of IP addresses MetalLB controls. We want this range to be on the docker kind network
docker network inspect -f '{{.IPAM.Config}}' kind

kubectl apply -f kind/metallb-cm-aws.yaml --context $CTX_CLUSTER1
kubectl apply -f kind/metallb-cm-google.yaml --context $CTX_CLUSTER2
kubectl apply -f kind/metallb-cm-azure.yaml --context $CTX_CLUSTER3

echo "
CTX_CLUSTER1=kind-aws-cluster
CTX_CLUSTER2=kind-google-cluster
CTX_CLUSTER3=kind-azure-cluster
"

kubectx cluster1=$CTX_CLUSTER1
kubectx cluster2=$CTX_CLUSTER2
kubectx cluster3=$CTX_CLUSTER3

