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
echo -d "#  Create EKS clusters                                                              #"
echo -e "########################################################################################"
read -p "Press any key to continue"

eksctl create cluster -f clusters-tony/cluster1.yaml
read -p "Press any key to continue"

eksctl create cluster -f clusters-tony/cluster2.yaml
read -p "Press any key to continue"

# Update contexts
aws eks update-kubeconfig --region us-east-1 --name cluster1
aws eks update-kubeconfig --region us-east-1 --name cluster2