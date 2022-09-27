#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will install Kiali on Isio multi-cluster                               #"
echo -e "########################################################################################"
read -p "Press any key to begin"

kubectl apply -f kiali/jaeger.yaml -n istio-system
kubectl apply -f kiali/prometheus.yaml -n istio-system
kubectl apply -f kiali/grafana.yaml -n istio-system

kubectl apply -f kiali/kiali.yaml -n istio-system

kubectl rollout status deployment/kiali -n istio-system

# Start the Kiali Dashboard in the Browser
istioctl dashboard kiali &