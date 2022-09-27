#!/bin/bash

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
echo -e "#   This script will install Isio multi-cluster                                        #"
echo -e "########################################################################################"
read -p "Press any key to begin"

######################
# Prep Istio
#####################
kubectl --context ${CLUSTER} create ns istio-system

# Only run redis-cart on one of the clusters
if [ ${CLUSTER} = "cluster1" ]
then
    # Add labels
    kubectl --context="${CLUSTER1}" get namespace istio-system && kubectl --context="${CLUSTER1}" label namespace istio-system topology.istio.io/network=network1

    # Add secrets
    kubectl --context="${CLUSTER1}" create secret generic cacerts -n istio-system --from-file=certs/cluster1/ca-cert.pem --from-file=certs/cluster1/ca-key.pem --from-file=certs/cluster1/root-cert.pem --from-file=certs/cluster1/cert-chain.pem

    # Install istio
    istioctl install -f istio/istio1.yaml --context "${CLUSTER1}"

    # Add secrets
    istioctl x create-remote-secret --context="${CLUSTER1}" --name=cluster1 | kubectl apply -f - --context="${CLUSTER2}"
    istioctl x create-remote-secret --context="${CLUSTER1}" --name=cluster1 | kubectl apply -f - --context="${CLUSTER3}"
elif [ ${CLUSTER} = "cluster2" ]
then
    # Add labels
    kubectl --context="${CLUSTER2}" get namespace istio-system && kubectl --context="${CLUSTER2}" label namespace istio-system topology.istio.io/network=network2

    # Add secrets
    kubectl --context="${CLUSTER2}" create secret generic cacerts -n istio-system --from-file=certs/cluster2/ca-cert.pem --from-file=certs/cluster2/ca-key.pem --from-file=certs/cluster2/root-cert.pem --from-file=certs/cluster2/cert-chain.pem

    # Install istio
    istioctl install -f istio/istio2.yaml --context "${CLUSTER2}"

    # Add secrets
    istioctl x create-remote-secret --context="${CLUSTER2}" --name=cluster2 | kubectl apply -f - --context="${CLUSTER1}"
    istioctl x create-remote-secret --context="${CLUSTER2}" --name=cluster2 | kubectl apply -f - --context="${CLUSTER3}"
elif [ ${CLUSTER} = "cluster3" ]
then
    # Add labels
    kubectl --context="${CLUSTER3}" get namespace istio-system && kubectl --context="${CLUSTER3}" label namespace istio-system topology.istio.io/network=network3

    # Add secrets
    kubectl --context="${CLUSTER3}" create secret generic cacerts -n istio-system --from-file=certs/cluster3/ca-cert.pem --from-file=certs/cluster3/ca-key.pem --from-file=certs/cluster3/root-cert.pem --from-file=certs/cluster3/cert-chain.pem

    # Install istio
    istioctl install -f istio/istio3.yaml --context "${CLUSTER3}"

    # Add secrets
    istioctl x create-remote-secret --context="${CLUSTER3}" --name=cluster3 | kubectl apply -f - --context="${CLUSTER1}"
    istioctl x create-remote-secret --context="${CLUSTER3}" --name=cluster3 | kubectl apply -f - --context="${CLUSTER2}"
else
    echo -e "Invalid input"
fi

# Add Istio gateways
kubectl apply -f istio/istio-ew-gw.yaml --context "${CLUSTER}"

echo -e "##############################################################################################################"
echo -e "Go to aws console, select the east west elb .. listeners ..then select the target group for 15443...         #"
echo -e "   and then go to attribute ..edit to remove the client ip preserve ( Preserve client IP addresses)          #"   
echo -e "##############################################################################################################"