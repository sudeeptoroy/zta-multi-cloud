#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will delete the Online Boutique Decomposed on Istio multi-cluster      #"
echo -e "########################################################################################"
read -p "Press any key to begin"

NS0="99995-990005-1001-dev"
NS1="99995-990005-1002-dev"
NS2="99995-990005-1003-dev"
NS3="99992-990002-1002-dev"
NS4="99996-990006-1002-dev"
NS5="99997-990007-1002-dev"
NS6="99998-990008-1002-dev"
NS7="99990-900002-9002-dev"

if [ $1 = "cluster1" ]
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
