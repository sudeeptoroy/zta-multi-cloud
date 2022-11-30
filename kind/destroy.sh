#/bin/bash
kind get clusters

kind delete cluster --name=aws-cluster
kind delete cluster --name=google-cluster
kind delete cluster --name=azure-cluster

# kind delete clusters aws-cluster azure-cluster google-cluster
