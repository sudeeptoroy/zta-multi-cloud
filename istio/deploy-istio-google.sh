#/bin/bash

#kubectl create ns istio-system
#sleep 2
#istioctl install -f istio-config-google.yaml --skip-confirmation
istioctl install -f istio-conf-new-google.yaml --skip-confirmation
kubectl apply -f auth.yaml
kubectl apply -f istio-ew-gw.yaml
