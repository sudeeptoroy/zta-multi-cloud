#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will move from a segregated to a replicated architecture for the Online "
echo -e "#   Boutique application"
echo -e "########################################################################################"
read -p "Press any key to begin"

kubectl scale -n $NS0 deploy frontend --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS0 deploy frontend --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS1 deploy adservice --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS1 deploy adservice --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS1 deploy recommendationservice --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS1 deploy recommendationservice --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS1 deploy productcatalogservice --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS1 deploy productcatalogservice --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS3 deploy checkoutservice --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS3 deploy checkoutservice --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS4 deploy cartservice --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS4 deploy cartservice --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS5 deploy paymentservice --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS5 deploy paymentservice --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS5 deploy shippingservice --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS5 deploy shippingservice --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS5 deploy currencyservice --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS5 deploy currencyservice --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS6 deploy emailservice --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS6 deploy emailservice --replicas=1 --context=$CLUSTER2

kubectl scale -n $NS2 deploy redis-cart --replicas=1 --context=$CLUSTER1
kubectl scale -n $NS2 deploy redis-cart --replicas=0 --context=$CLUSTER2
