#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will install Spire for Isio multi-cluster demo                         #"
echo -e "########################################################################################"
read -p "Press any key to begin"

echo -e "########################################################################################"
echo -e "#   Cluster1 install                                                                   #"
echo -e "########################################################################################"
# Create the namespace
kubectl --context="${CLUSTER1}" create ns spire

# Create the k8s-workload-registrar crd, configmap and associated role bindingsspace
kubectl --context="${CLUSTER1}" apply \
    -f ./spire/k8s-workload-registrar-crd-cluster-role.yaml \
    -f ./spire/k8s-workload-registrar-crd-configmap-cluster1.yaml \
    -f ./spire/spiffeid.spiffe.io_spiffeids.yaml

# Create the server’s service account, configmap and associated role bindings
kubectl --context="${CLUSTER1}" apply \
    -f ./spire/server-account.yaml \
    -f ./spire/spire-bundle-configmap.yaml \
    -f ./spire/server-cluster-role.yaml

# Deploy the server configmap and statefulset
kubectl --context="${CLUSTER1}" apply \
    -f ./spire/server-configmap-cluster1.yaml \
    -f ./spire/server-statefulset.yaml \
    -f ./spire/server-service.yaml

# Configuring and deploying the SPIRE Agent
kubectl --context="${CLUSTER1}" apply \
    -f ./spire/agent-account.yaml \
    -f ./spire/agent-cluster-role.yaml

sleep 2

kubectl --context="${CLUSTER1}" apply \
    -f ./spire/agent-configmap-cluster1.yaml \
    -f ./spire/agent-daemonset.yaml

# Applying SPIFFE CSI Driver configuration
kubectl --context="${CLUSTER1}" apply -f spiffe-csi-driver.yaml

kubectl --context="${CLUSTER1}" -n spire rollout status statefulset spire-server
kubectl --context="${CLUSTER1}" -n spire rollout status daemonset spire-agent

cluster1_bundle=$(kubectl --context="${CLUSTER1}" exec --stdin spire-server-0 -c spire-server -n spire  -- /opt/spire/bin/spire-server bundle show -format spiffe -socketPath /run/spire/sockets/server.sock)

echo -e "########################################################################################"
echo -e "#   Cluster2 install                                                                   #"
echo -e "########################################################################################"
# Create the namespace
kubectl --context="${CLUSTER2}" create ns spire

# Create the k8s-workload-registrar crd, configmap and associated role bindingsspace
kubectl --context="${CLUSTER2}" apply \
    -f ./spire/k8s-workload-registrar-crd-cluster-role.yaml \
    -f ./spire/k8s-workload-registrar-crd-configmap-cluster2.yaml \
    -f ./spire/spiffeid.spiffe.io_spiffeids.yaml

# Create the server’s service account, configmap and associated role bindings
kubectl --context="${CLUSTER2}" apply \
    -f ./spire/server-account.yaml \
    -f ./spire/spire-bundle-configmap.yaml \
    -f ./spire/server-cluster-role.yaml

# Deploy the server configmap and statefulset
kubectl --context="${CLUSTER2}" apply \
    -f ./spire/server-configmap-cluster2.yaml \
    -f ./spire/server-statefulset.yaml \
    -f ./spire/server-service.yaml

# Configuring and deploying the SPIRE Agent
kubectl --context="${CLUSTER2}" apply \
    -f ./spire/agent-account.yaml \
    -f ./spire/agent-cluster-role.yaml

sleep 2

kubectl --context="${CLUSTER2}" apply \
    -f ./spire/agent-configmap-cluster2.yaml \
    -f ./spire/agent-daemonset.yaml

# Applying SPIFFE CSI Driver configuration
kubectl --context="${CLUSTER2}" apply -f spiffe-csi-driver.yaml

kubectl --context="${CLUSTER2}" -n spire rollout status statefulset spire-server
kubectl --context="${CLUSTER2}" -n spire rollout status daemonset spire-agent

cluster2_bundle=$(kubectl --context="${CLUSTER2}" exec --stdin spire-server-0 -c spire-server -n spire  -- /opt/spire/bin/spire-server bundle show -format spiffe -socketPath /run/spire/sockets/server.sock)

# Set domain.test bundle to example.org SPIRE bundle endpoint
kubectl --context="${CLUSTER1}" exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server bundle set -format spiffe -id spiffe://google.com -socketPath /run/spire/sockets/server.sock <<< "$cluster2_bundle"

# Set example.org bundle to domain.test SPIRE bundle endpoint
kubectl --context="${CLUSTER2}" exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server bundle set -format spiffe -id spiffe://aws.com -socketPath /run/spire/sockets/server.sock <<< "$cluster1_bundle"
