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
echo -e "#   This script will install Spire on ${CLUSTER} for Isio multi-cluster demo          #"
echo -e "########################################################################################"
read -p "Press any key to begin"

echo -e "########################################################################################"
echo -e "#   ${CLUSTER} install                                                                 #"
echo -e "########################################################################################"
# Create the namespace
kubectl --context="${CLUSTER}" create ns spire

# Create the k8s-workload-registrar crd, configmap and associated role bindingsspace
kubectl --context="${CLUSTER}" apply \
    -f ./spire/k8s-workload-registrar-crd-cluster-role.yaml \
    -f ./spire/k8s-workload-registrar-crd-configmap-${CLUSTER}.yaml \
    -f ./spire/spiffeid.spiffe.io_spiffeids.yaml

# Create the server’s service account, configmap and associated role bindings
kubectl --context="${CLUSTER}" apply \
    -f ./spire/server-account.yaml \
    -f ./spire/spire-bundle-configmap.yaml \
    -f ./spire/server-cluster-role.yaml

# Deploy the server configmap and statefulset
kubectl --context="${CLUSTER}" apply \
    -f ./spire/server-configmap-${CLUSTER}.yaml \
    -f ./spire/server-statefulset.yaml \
    -f ./spire/server-service.yaml

# Configuring and deploying the SPIRE Agent
kubectl --context="${CLUSTER}" apply \
    -f ./spire/agent-account.yaml \
    -f ./spire/agent-cluster-role.yaml

sleep 2

kubectl --context="${CLUSTER}" apply \
    -f ./spire/agent-configmap-${CLUSTER}.yaml \
    -f ./spire/agent-daemonset.yaml

# Applying SPIFFE CSI Driver configuration
kubectl --context="${CLUSTER}" apply -f ./spire/spiffe-csi-driver.yaml

kubectl --context="${CLUSTER}" -n spire rollout status statefulset spire-server
kubectl --context="${CLUSTER}" -n spire rollout status daemonset spire-agent