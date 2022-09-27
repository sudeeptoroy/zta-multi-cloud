#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will delete the Online Boutique Decomposed on Istio multi-cluster      #"
echo -e "########################################################################################"
read -p "Press any key to begin"

if [ $1 == "cluster1" ]
then
    CLUSTER=cluster1
else
    CLUSTER=cluster2
fi

kubectl --context=${CLUSTER} delete ns ${NS0}
kubectl --context=${CLUSTER} delete ns ${NS1}
kubectl --context=${CLUSTER} delete ns ${NS2}
kubectl --context=${CLUSTER} delete ns ${NS3}
kubectl --context=${CLUSTER} delete ns ${NS4}
kubectl --context=${CLUSTER} delete ns ${NS5}
kubectl --context=${CLUSTER} delete ns ${NS6}
kubectl --context=${CLUSTER} delete ns ${NS7}
