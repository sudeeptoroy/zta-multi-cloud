#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will install the Online Boutique Decomposed into Istio multi-cluster   #"
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

echo -e "########################################################################################"
echo -e "Deploy frontend service to namespace ${NS0} on cluster $1" 
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS0}

if [ ${CLUSTER} = "cluster1" ]
then
    kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/frontend-cluster1.yaml --namespace ${NS0}
else
    kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/frontend-cluster2.yaml --namespace ${NS0}
fi

echo -e "########################################################################################"
echo -e "Deploy services to namespace ${NS1}"
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS1}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/productcatalogservice.yaml --namespace ${NS1}
kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/recommendationservice.yaml --namespace ${NS1}
kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/cartservice.yaml --namespace ${NS1}
kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/checkoutservice.yaml --namespace ${NS1}
kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/shippingservice.yaml --namespace ${NS1}

echo -e "########################################################################################"
echo -e "Deploy redis service to namespace ${NS2}"
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS2}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/redis.yaml --namespace ${NS2}

echo -e "########################################################################################"
echo -e "Deploy paymentservice service to namespace ${NS3}"
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS3}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/paymentservice.yaml --namespace ${NS3}

echo -e "########################################################################################"
echo -e "Deploy adservice service to namespace ${NS4}"
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS4}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/adservice.yaml --namespace ${NS4}

echo -e "########################################################################################"
echo -e "Deploy currencyservice service to namespace ${NS5}"
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS5}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/currencyservice.yaml --namespace ${NS5}

echo -e "########################################################################################"
echo -e "Deploy emailservice service to namespace ${NS6}"
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS6}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/emailservice.yaml --namespace ${NS6}

echo -e "########################################################################################"
echo -e "Deploy loadgenerator service to namespace ${NS7}"
echo -e "########################################################################################"
read -p "Press any key to begin"
kubectl --context=${CLUSTER} create ns ${NS7}

kubectl --context=${CLUSTER} apply -f ./online-boutique-decomposed/loadgenerator.yaml --namespace ${NS7}

# Only run redis-cart on one cluster
if [ ${CLUSTER} = "cluster1" ]
then
    kubectl scale -n99995-990005-1003-dev deploy redis-cart --replicas=1 --context=$CLUSTER
else
    kubectl scale -n99995-990005-1003-dev deploy redis-cart --replicas=0 --context=$CLUSTER
fi

echo -e "########################################################################################"
echo -e "Configure Istio on namespace ${NS7}"
echo -e "########################################################################################"
read -p "Press any key to begin"

kubectl --context=${CLUSTER} apply -f ./online-boutique/istio-manifest.yaml --namespace ${NS0}
read -p "Press any key to continue"

INGRESS_HOST="$(kubectl --context=${CLUSTER} --namespace istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"

echo "$INGRESS_HOST"

curl -v "http://$INGRESS_HOST"