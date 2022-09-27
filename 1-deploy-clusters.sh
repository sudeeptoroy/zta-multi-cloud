#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will deploy EKS Clusters                                        #"
echo -e "########################################################################################"
read -p "Press any key to begin"

echo -e "########################################################################################"
echo -e "#  Create a VPC                                                                        #"
echo -e "########################################################################################"
read -p "Press any key to begin"

echo -e "########################################################################################"
echo -e "#  Create 2 EKS clusters                                                             #"
echo -e "########################################################################################"
read -p "Press any key to continue"

echo -e "   Cluster1"
eksctl create cluster -f clusters/cluster1.yaml
read -p "Press any key to continue"

echo -e "   Cluster2"
eksctl create cluster -f clusters/cluster2.yaml
read -p "Press any key to continue"

echo -e "   Cluster3"
eksctl create cluster -f clusters/cluster3.yaml

# Rename Clusters
kubectx tfarinacci@cluster1.us-east-1.eksctl.io=cluster1
kubectx tfarinacci@cluster2.us-east-1.eksctl.io=cluster2
kubectx tfarinacci@cluster3.us-east-1.eksctl.io=cluster3