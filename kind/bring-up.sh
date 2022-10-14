#!/bin/bash

set -e

# bring up kind cluster 1
kind create cluster --config=kind-c1.yaml

# bring up kind cluster 2
kind create cluster --config=kind-c2.yaml

# install LB for the east west gw
kubectl apply -f metallb.yaml --context=kind-aws
kubectl apply -f metallb.yaml --context=kind-google

#In order to complete the configuration, we need to provide a range of IP addresses MetalLB controls. We want this range to be on the docker kind network
docker network inspect -f '{{.IPAM.Config}}' kind

kubectl apply -f metallb-cm-c1.yaml --context kind-aws
kubectl apply -f metallb-cm-c2.yaml --context kind-google

