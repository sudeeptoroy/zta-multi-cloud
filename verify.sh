#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will test Isio multi-cluster                                           #"
echo -e "########################################################################################"
read -p "Press any key to begin"

# Create test namespace
kubectl create --context="${CLUSTER1}" namespace sample
kubectl create --context="${CLUSTER2}" namespace sample
read -p "Press any key to continue"

# Enable Istio on namespaces
kubectl label --context="${CLUSTER1}" namespace sample istio-injection=enabled
kubectl label --context="${CLUSTER2}" namespace sample istio-injection=enabled
read -p "Press any key to continue"

kubectl apply --context="${CLUSTER1}" -f helloworld/helloworld.yaml -l service=helloworld -n sample
kubectl apply --context="${CLUSTER2}" -f helloworld/helloworld.yaml -l service=helloworld -n sample
read -p "Press any key to continue"

kubectl apply --context="${CLUSTER1}" -f helloworld/helloworld.yaml -l version=v1 -n sample
read -p "Press any key to continue"

kubectl get pod --context="${CLUSTER1}" -n sample -l app=helloworld
read -p "Press any key to continue"

kubectl get pod --context="${CLUSTER1}" -n sample -l app=helloworld
read -p "Press any key to continue"

kubectl apply --context="${CLUSTER2}" -f helloworld/helloworld.yaml -l version=v2 -n sample
read -p "Press any key to continue"

kubectl get pod --context="${CLUSTER2}" -n sample -l app=helloworld
read -p "Press any key to continue"

kubectl apply --context="${CLUSTER1}" -f helloworld/sleep.yaml -n sample
kubectl apply --context="${CLUSTER2}" -f helloworld/sleep.yaml -n sample
read -p "Press any key to continue"

kubectl get pod --context="${CLUSTER1}" -n sample -l app=sleep
kubectl get pod --context="${CLUSTER2}" -n sample -l app=sleep

read -p "Press any key to test connectivity"

# Test connectivity
kubectl exec --context="${CLUSTER1}" -n sample -c sleep "$(kubectl get pod --context="${CLUSTER1}" -n sample -l app=sleep -o jsonpath='{.items[0].metadata.name}')" -- curl -sS helloworld.sample:5000/hello

kubectl exec --context="${CLUSTER2}" -n sample -c sleep "$(kubectl get pod --context="${CLUSTER2}" -n sample -l app=sleep -o jsonpath='{.items[0].metadata.name}')" -- curl -sS helloworld.sample:5000/hello
