#!/bin/bash

echo -e "########################################################################################"
echo -e "#  Create 3rd EKS cluster                                                              #"
echo -e "########################################################################################"
read -p "Press any key to continue"

# Deploy NS1 to Cluster3
echo -e "########################################################################################"
echo -e " Deploy productcatalog, recommendationm and ad services to namespace ${NS1}"
echo -e "########################################################################################"
kubectl --context=${CLUSTER3} create ns ${NS1}

kubectl --context=${CLUSTER3} apply -f ./online-boutique-decomposed/productcatalogservice.yaml --namespace ${NS1}
kubectl --context=${CLUSTER3} apply -f ./online-boutique-decomposed/recommendationservice.yaml --namespace ${NS1}
kubectl --context=${CLUSTER3} apply -f ./online-boutique-decomposed/adservice.yaml --namespace ${NS1}

echo -e "########################################################################################"
echo -e " Deploy emailservice service to namespace ${NS6}"
echo -e "########################################################################################"
kubectl --context=${CLUSTER3} create ns ${NS6}

kubectl --context=${CLUSTER3} apply -f ./online-boutique-decomposed/emailservice.yaml --namespace ${NS6}

echo -e "########################################################################################"
echo -e " Disable services on Cluster 2"
echo -e "########################################################################################"
read -p "Press any key to continue"
kubectl scale -n $NS1 deploy adservice --replicas=0 --context=$CLUSTER2
kubectl scale -n $NS1 deploy recommendationservice --replicas=0 --context=$CLUSTER2
kubectl scale -n $NS1 deploy productcatalogservice --replicas=0 --context=$CLUSTER2

kubectl scale -n $NS6 deploy emailservice --replicas=0 --context=$CLUSTER2