#!/bin/bash

istioctl kube-inject --filename sleep.yaml | kubectl apply -f -

kubectl apply -f ./service-entry.yaml
