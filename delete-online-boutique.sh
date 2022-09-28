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
echo -e "#   This script will delete the Online Boutique Decomposed on Istio multi-cluster      #"
echo -e "########################################################################################"
read -p "Press any key to begin"

kubectl --context=${CLUSTER} delete ns ${NS0}
kubectl --context=${CLUSTER} delete ns ${NS1}
kubectl --context=${CLUSTER} delete ns ${NS2}
kubectl --context=${CLUSTER} delete ns ${NS3}
kubectl --context=${CLUSTER} delete ns ${NS4}
kubectl --context=${CLUSTER} delete ns ${NS5}
kubectl --context=${CLUSTER} delete ns ${NS6}
kubectl --context=${CLUSTER} delete ns ${NS7}
