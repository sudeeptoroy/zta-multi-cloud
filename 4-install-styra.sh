#!/bin/bash

# Check for input
if [ $1 == "cluster1" ]
then
    CLUSTER=cluster1
elif [ $1 == "cluster2" ]
then
    CLUSTER=cluster2
elif [ $1 == "cluster3" ]
then
    CLUSTER=cluster3
else
    echo -e "########################################################################################"
    echo -e "   Must specify cluster1, cluster2, cluster3" 
    echo -e "########################################################################################"
    exit 1    
fi

echo -e "########################################################################################"
echo -e "#   This script will install Styra DAS on  Isio multi-cluster                          #"
echo -e "########################################################################################"
read -p "Press any key to begin"

# Label put of scope namespace
kubectl label ns kube-system openpolicyagent.org/webhook=ignore --context="${CLUSTER}"
kubectl label ns kube-public openpolicyagent.org/webhook=ignore --context="${CLUSTER}"
kubectl label ns kube-node-lease openpolicyagent.org/webhook=ignore --context="${CLUSTER}"
kubectl label ns istio-system openpolicyagent.org/webhook=ignore --context="${CLUSTER}"

# Install Styra
# Only run redis-cart on one of the clusters
if [ ${CLUSTER} == "cluster1" ]
then
    kubectl apply -f styra/cluster1.yaml -n styra-system --context="${CLUSTER}"
elif [ ${CLUSTER} == "cluster2" ]
then
    kubectl apply -f styra/cluster2.yaml -n styra-system --context="${CLUSTER}"
elif [ ${CLUSTER} == "cluster3" ]
then
    kubectl apply -f styra/cluster3.yaml -n styra-system --context="${CLUSTER}"
else
    echo -e "Invalid input"
fi