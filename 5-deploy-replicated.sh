#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will install the Online Boutique Decomposed into Istio multi-cluster   #"
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

echo -e "########################################################################################"
echo -e "Deploy frontend service to namespace ${NS0} on cluster $1" 
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS0}

if [ ${CLUSTER} = "cluster1" ]
then
    kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/frontend-cluster1.yaml --namespace ${NS0}
elif [ ${CLUSTER} = "cluster2" ]
then
    kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/frontend-cluster2.yaml --namespace ${NS0}
elif [ ${CLUSTER} = "cluster3" ]
then
    kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/frontend-cluster3.yaml --namespace ${NS0}
else
    echo -e "########################################################################################"
    echo -e "   Must specify cluster1, cluster2, cluster3" 
    echo -e "########################################################################################"
    exit 1
fi

echo -e "########################################################################################"
echo -e "Deploy productcatalog, recommendationm and ad services to namespace ${NS1}"
echo -e "########################################################################################"
kubectl --context=${CLUSTER} create ns ${NS1}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/productcatalogservice.yaml --namespace ${NS1}
kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/recommendationservice.yaml --namespace ${NS1}
kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/adservice.yaml --namespace ${NS1}

echo -e "########################################################################################"
echo -e "Deploy redis service to namespace ${NS2}"
echo -e "########################################################################################"
kubectl --context=${CLUSTER} create ns ${NS2}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/redis.yaml --namespace ${NS2}

echo -e "########################################################################################"
echo -e "Deploy checkout service to namespace ${NS3}"
echo -e "########################################################################################"
kubectl --context=${CLUSTER} create ns ${NS3}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/checkoutservice.yaml --namespace ${NS3}

echo -e "########################################################################################"
echo -e "Deploy cart service to namespace ${NS4}"
echo -e "########################################################################################"
kubectl --context=${CLUSTER} create ns ${NS4}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/cartservice.yaml --namespace ${NS4}

echo -e "########################################################################################"
echo -e "Deploy currency, payment, and shipping services to namespace ${NS5}"
echo -e "########################################################################################"
kubectl --context=${CLUSTER} create ns ${NS5}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/currencyservice.yaml --namespace ${NS5}
kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/paymentservice.yaml --namespace ${NS5}
kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/shippingservice.yaml --namespace ${NS5}

echo -e "########################################################################################"
echo -e "Deploy emailservice service to namespace ${NS6}"
echo -e "########################################################################################"
kubectl --context=${CLUSTER} create ns ${NS6}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/emailservice.yaml --namespace ${NS6}

echo -e "########################################################################################"
echo -e "Deploy loadgenerator service to namespace ${NS7}"
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS7}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/loadgenerator.yaml --namespace ${NS7}

# Only run redis-cart on one of the clusters
if [ ${CLUSTER} = "cluster1" ]
then
    kubectl scale -n99995-990005-1003-dev deploy redis-cart --replicas=1 --context=$CLUSTER
elif [ ${CLUSTER} = "cluster2" ]
then
    kubectl scale -n99995-990005-1003-dev deploy redis-cart --replicas=0 --context=$CLUSTER
elif [ ${CLUSTER} = "cluster3" ]
then
    kubectl scale -n99995-990005-1003-dev deploy redis-cart --replicas=0 --context=$CLUSTER
else
    echo -e "Invalid input"
fi

echo -e "########################################################################################"
echo -e "Configure Istio on namespace ${NS0}"
echo -e "########################################################################################"
read -p "Press any key to begin"

kubectl --context=${CLUSTER} apply -f ./online-boutique/istio-manifest.yaml --namespace ${NS0}
read -p "Press any key to continue"

INGRESS_HOST="$(kubectl --context=${CLUSTER} --namespace istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"

echo "$INGRESS_HOST"

curl -v "http://$INGRESS_HOST"