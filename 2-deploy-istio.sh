#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will install Isio multi-cluster                                        #"
echo -e "########################################################################################"
read -p "Press any key to begin"

######################
# Prep Istio
#####################
kubectl --context ${CLUSTER1} create ns istio-system
kubectl --context ${CLUSTER2} create ns istio-system
kubectl --context ${CLUSTER3} create ns istio-system

# Add labels
kubectl --context="${CLUSTER1}" get namespace istio-system && kubectl --context="${CLUSTER1}" label namespace istio-system topology.istio.io/network=network1
kubectl --context="${CLUSTER2}" get namespace istio-system && kubectl --context="${CLUSTER2}" label namespace istio-system topology.istio.io/network=network2
kubectl --context="${CLUSTER3}" get namespace istio-system && kubectl --context="${CLUSTER3}" label namespace istio-system topology.istio.io/network=network3

# Add secrets
kubectl --context="${CLUSTER1}" create secret generic cacerts -n istio-system --from-file=certs/cluster1/ca-cert.pem --from-file=certs/cluster1/ca-key.pem --from-file=certs/cluster1/root-cert.pem --from-file=certs/cluster1/cert-chain.pem
kubectl --context="${CLUSTER2}" create secret generic cacerts -n istio-system --from-file=certs/cluster2/ca-cert.pem --from-file=certs/cluster2/ca-key.pem --from-file=certs/cluster2/root-cert.pem --from-file=certs/cluster2/cert-chain.pem
kubectl --context="${CLUSTER3}" create secret generic cacerts -n istio-system --from-file=certs/cluster3/ca-cert.pem --from-file=certs/cluster3/ca-key.pem --from-file=certs/cluster3/root-cert.pem --from-file=certs/cluster3/cert-chain.pem

echo -e "########################################################################################"
echo -e "#  Install Istio                                                                       #"
echo -e "########################################################################################"
read -p "Press any key to continue"

istioctl install -f istio/istio1.yaml --context "${CLUSTER1}"
istioctl install -f istio/istio2.yaml --context "${CLUSTER2}"
istioctl install -f istio/istio3.yaml --context "${CLUSTER3}"

# Add Istio gateways
kubectl apply -f istio/istio-ew-gw.yaml --context "${CLUSTER1}"
kubectl apply -f istio/istio-ew-gw.yaml --context "${CLUSTER2}"
kubectl apply -f istio/istio-ew-gw.yaml --context "${CLUSTER3}"

# Add secrets
istioctl x create-remote-secret --context="${CLUSTER1}" --name=cluster1 | kubectl apply -f - --context="${CLUSTER2}"
istioctl x create-remote-secret --context="${CLUSTER2}" --name=cluster2 | kubectl apply -f - --context="${CLUSTER1}"

# TODO: Check this
istioctl x create-remote-secret --context="${CLUSTER1}" --name=cluster2 | kubectl apply -f - --context="${CLUSTER3}"
istioctl x create-remote-secret --context="${CLUSTER3}" --name=cluster2 | kubectl apply -f - --context="${CLUSTER1}"

echo -e "##############################################################################################################"
echo -e "Go to aws console, select the east west elb .. listeners ..then select the target group for 15443...         #"
echo -e "   and then go to attribute ..edit to remove the client ip preserve ( Preserve client IP addresses)          #"   
echo -e "##############################################################################################################"
