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
echo -e "#   This script will install Kiali on Isio multi-cluster                               #"
echo -e "########################################################################################"
read -p "Press any key to begin"

kubectl --context=${CLUSTER} apply -f kiali/jaeger.yaml -n istio-system
kubectl --context=${CLUSTER} apply -f kiali/prometheus.yaml -n istio-system
kubectl --context=${CLUSTER} apply -f kiali/grafana.yaml -n istio-system

kubectl --context=${CLUSTER} apply -f kiali/kiali.yaml -n istio-system

kubectl --context=${CLUSTER} rollout status deployment/kiali -n istio-system

# Start the Kiali Dashboard in the Browser
istioctl --context=${CLUSTER} dashboard kiali &