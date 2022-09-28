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
echo -e "#   This script will enable Istio  on cluster ${CLUSTER}                               #"
echo -e "########################################################################################"
read -p "Press any key to begin"

# Label namespaces
kubectl --context=${CLUSTER} label ns ${NS0} istio-injection=enabled --overwrite
kubectl --context=${CLUSTER} label ns ${NS1} istio-injection=enabled --overwrite
kubectl --context=${CLUSTER} label ns ${NS2} istio-injection=enabled --overwrite
kubectl --context=${CLUSTER} label ns ${NS3} istio-injection=enabled --overwrite
kubectl --context=${CLUSTER} label ns ${NS4} istio-injection=enabled --overwrite
kubectl --context=${CLUSTER} label ns ${NS5} istio-injection=enabled --overwrite
kubectl --context=${CLUSTER} label ns ${NS6} istio-injection=enabled --overwrite
kubectl --context=${CLUSTER} label ns ${NS7} istio-injection=enabled --overwrite

sleep 1

# Restart pods
kubectl --context=${CLUSTER} delete pod --all --namespace  ${NS0}
kubectl --context=${CLUSTER} delete pod --all --namespace  ${NS1}
kubectl --context=${CLUSTER} delete pod --all --namespace  ${NS2}
kubectl --context=${CLUSTER} delete pod --all --namespace  ${NS3}
kubectl --context=${CLUSTER} delete pod --all --namespace  ${NS4}
kubectl --context=${CLUSTER} delete pod --all --namespace  ${NS5}
kubectl --context=${CLUSTER} delete pod --all --namespace  ${NS6}
kubectl --context=${CLUSTER} delete pod --all --namespace  ${NS7}
