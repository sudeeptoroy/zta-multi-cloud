#/bin/bash

#kubectl create ns istio-system
#kubectl label namespace istio-system topology.istio.io/network=aws-network
#sleep 2
#istioctl install -f istio-config-aws.yaml --skip-confirmation
istioctl install -f istio-conf-new-aws.yaml --skip-confirmation
kubectl apply -f auth.yaml
kubectl apply -f istio-ew-gw.yaml
