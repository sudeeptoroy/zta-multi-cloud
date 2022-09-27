#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will move from a replicated to a segregated architecture for the Online"
echo -e "#   Boutique application"
echo -e "########################################################################################"
read -p "Press any key to begin"

kubectl scale -n 99995-990005-1001-dev deploy frontend --replicas=1 --context=$CLUSTER1
kubectl scale -n 99995-990005-1001-dev deploy frontend --replicas=0 --context=$CLUSTER2

kubectl scale -n 99992-990002-1002-dev deploy paymentservice --replicas=0 --context=$CLUSTER1
kubectl scale -n 99992-990002-1002-dev deploy paymentservice --replicas=1 --context=$CLUSTER2

kubectl scale -n99995-990005-1002-dev deploy cartservice --replicas=0 --context=$CLUSTER1
kubectl scale -n99995-990005-1002-dev deploy cartservice --replicas=1 --context=$CLUSTER2

kubectl scale -n99995-990005-1002-dev deploy checkoutservice --replicas=1 --context=$CLUSTER1
kubectl scale -n99995-990005-1002-dev deploy checkoutservice --replicas=0 --context=$CLUSTER2

kubectl scale -n99995-990005-1002-dev deploy productcatalogservice --replicas=0 --context=$CLUSTER1
kubectl scale -n99995-990005-1002-dev deploy productcatalogservice --replicas=1 --context=$CLUSTER2

kubectl scale -n99995-990005-1002-dev deploy recommendationservice --replicas=1 --context=$CLUSTER1
kubectl scale -n99995-990005-1002-dev deploy recommendationservice --replicas=0 --context=$CLUSTER2

kubectl scale -n99995-990005-1002-dev deploy shippingservice --replicas=1 --context=$CLUSTER1
kubectl scale -n99995-990005-1002-dev deploy shippingservice --replicas=0 --context=$CLUSTER2

kubectl scale -n99996-990006-1002-dev deploy adservice --replicas=0 --context=$CLUSTER1
kubectl scale -n99996-990006-1002-dev deploy adservice --replicas=1 --context=$CLUSTER2

kubectl scale -n99997-990007-1002-dev deploy currencyservice --replicas=1 --context=$CLUSTER1
kubectl scale -n99997-990007-1002-dev deploy currencyservice --replicas=0 --context=$CLUSTER2

kubectl scale -n99998-990008-1002-dev deploy emailservice --replicas=0 --context=$CLUSTER1
kubectl scale -n99998-990008-1002-dev deploy emailservice --replicas=1 --context=$CLUSTER2

kubectl scale -n99995-990005-1003-dev deploy redis-cart --replicas=1 --context=$CLUSTER1
kubectl scale -n99995-990005-1003-dev deploy redis-cart --replicas=0 --context=$CLUSTER2
