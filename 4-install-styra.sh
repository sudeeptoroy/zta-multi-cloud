#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will install Styra DAS on  Isio multi-cluster                          #"
echo -e "########################################################################################"
read -p "Press any key to begin"

# Check for input
if [ $1 = "cluster1" ]
then
    CLUSTER=cluster1
elif [ $1 = "cluster2" ]
then
    CLUSTER=cluster2
elif [ $1 = "cluster3" ]
then
    CLUSTER=cluster3
else
    echo -e "########################################################################################"
    echo -e "   Must specify cluster1, cluster2, cluster3" 
    echo -e "########################################################################################"
    exit 1    
fi

# Label put of scope namespace
kubectl label ns kube-system openpolicyagent.org/webhook=ignore --context="${CLUSTER}"
kubectl label ns kube-public openpolicyagent.org/webhook=ignore --context="${CLUSTER}"
kubectl label ns kube-node-lease openpolicyagent.org/webhook=ignore --context="${CLUSTER}"
kubectl label ns istio-system openpolicyagent.org/webhook=ignore --context="${CLUSTER}"

# Install Styra
kubectl apply -f styra/cluster1.yaml -n styra-system --context="${CLUSTER}"