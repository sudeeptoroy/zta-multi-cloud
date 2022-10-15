#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will deploy EKS Clusters                                               #"
echo -e "########################################################################################"
read -p "Press any key to begin"

echo -e "########################################################################################"
echo -e "#  Create a VPC                                                                        #"
echo -e "########################################################################################"
read -p "Press any key to begin"

echo -e "########################################################################################"
echo -e "#  Create 3 EKS clusters                                                              #"
echo -e "########################################################################################"
read -p "Press any key to continue"

echo -e "   Cluster1"
eksctl create cluster -f clusters/cluster1.yaml

echo -e "   Cluster2"
eksctl create cluster -f clusters/cluster2.yaml

#echo -e "   Cluster3"
#eksctl create cluster -f clusters/cluster3.yaml


aws eks update-kubeconfig  --name cluster1
aws eks update-kubeconfig  --name cluster2
#aws eks update-kubeconfig  --name cluster3

# Rename Clusters
kubectx cluster1=tfarinacci@cluster1.us-east-1.eksctl.io
kubectx cluster2=tfarinacci@cluster2.us-east-1.eksctl.io
#kubectx cluster3=tfarinacci@cluster3.us-east-1.eksctl.io


#kubectx cluster1=arn:aws:eks:us-east-1:398573787840:cluster/cluster1
#kubectx cluster2=arn:aws:eks:us-east-1:398573787840:cluster/cluster2
#kubectx cluster3=arn:aws:eks:us-east-1:398573787840:cluster/cluster3
