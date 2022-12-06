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
echo -e "#   This script will install Istio on ${CLUSTER} for Isio multi-cluster demo           #"
echo -e "########################################################################################"
read -p "Press any key to begin"

echo -e "########################################################################################"
echo -e "#   ${CLUSTER} install                                                                 #"
echo -e "########################################################################################"

cluster1_bundle=$(kubectl --context="${CLUSTER1}" exec --stdin spire-server-0 -c spire-server -n spire  -- /opt/spire/bin/spire-server bundle show -format spiffe -socketPath /run/spire/sockets/server.sock)
cluster2_bundle=$(kubectl --context="${CLUSTER2}" exec --stdin spire-server-0 -c spire-server -n spire  -- /opt/spire/bin/spire-server bundle show -format spiffe -socketPath /run/spire/sockets/server.sock)
cluster3_bundle=$(kubectl --context="${CLUSTER3}" exec --stdin spire-server-0 -c spire-server -n spire  -- /opt/spire/bin/spire-server bundle show -format spiffe -socketPath /run/spire/sockets/server.sock)

# Check for input
if [ "${CLUSTER}" == "cluster1" ]
then
    # Set domain.test bundle to example.org SPIRE bundle endpoint
    kubectl --context="${CLUSTER}" exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server bundle set -format spiffe -id spiffe://google.com -socketPath /run/spire/sockets/server.sock <<< "$cluster2_bundle"
    kubectl --context="${CLUSTER}" exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server bundle set -format spiffe -id spiffe://azure.com -socketPath /run/spire/sockets/server.sock <<< "$cluster3_bundle"
elif [ "${CLUSTER}" == "cluster2" ]
then
    # Set example.org bundle to domain.test SPIRE bundle endpoint
    kubectl --context="${CLUSTER}" exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server bundle set -format spiffe -id spiffe://aws.com -socketPath /run/spire/sockets/server.sock <<< "$cluster1_bundle"
    kubectl --context="${CLUSTER}" exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server bundle set -format spiffe -id spiffe://azure.com -socketPath /run/spire/sockets/server.sock <<< "$cluster3_bundle"
elif [ "${CLUSTER}" == "cluster3" ]
then
    # Set example.org bundle to domain.test SPIRE bundle endpoint
    kubectl --context="${CLUSTER}" exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server bundle set -format spiffe -id spiffe://aws.com -socketPath /run/spire/sockets/server.sock <<< "$cluster1_bundle"
    kubectl --context="${CLUSTER}" exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server bundle set -format spiffe -id spiffe://google.com -socketPath /run/spire/sockets/server.sock <<< "$cluster2_bundle"
else
    echo -e "########################################################################################"
    echo -e "   Must specify cluster1, cluster2, cluster3" 
    echo -e "########################################################################################"
    exit 1    
fi

#sleep 30
#
#echo -e "########################################################################################"
#echo -e "#   Istio install                                                                      #"
#echo -e "########################################################################################"
#read -p "Press any key to begin"
#kubectl --context ${CLUSTER} create ns istio-system
#
#istioctl --context="${CLUSTER}" install -f ./istio/istio-config-${CLUSTER}.yaml --skip-confirmation
#kubectl apply -f ./istio/auth.yaml
#kubectl apply -f ./istio/istio-ew-gw.yaml
