#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will run the the demo of Istio Mutlt-cluster with SPIRE and OPA        #"
echo -e "########################################################################################"
read -p "Press any key to begin"

echo -e "########################################################################################"
echo -e "#   Deploy the replicated architecture on cluster1                                     #"
echo -e "########################################################################################"
read -p "Press any key to begin"
./6-deploy-replicated.sh cluster1 

echo -e "########################################################################################"
echo -e "#   Deploy the replicated architecture on cluster2                                     #"
echo -e "########################################################################################"
read -p "Press any key to begin"
./6-deploy-replicated.sh cluster2 

echo -e "########################################################################################"
echo -e "#   Enable Istio on the replicated architecture on cluster1 and cluster2               #"
echo -e "########################################################################################"
read -p "Press any key to begin"
./7-enable-istio.sh cluster1
./7-enable-istio.sh cluster2
./7-enable-istio.sh cluster3

echo -e "########################################################################################"
echo -e "#   Deploy the segregated architecture on cluster1                                     #"
echo -e "########################################################################################"
read -p "Press any key to begin"
./8-deploy-segregated.sh 

echo -e "########################################################################################"
echo -e "#   Deploy the segregated architecture on cluster3 and disable cluster2                #"
echo -e "########################################################################################"
read -p "Press any key to begin"
./9-deploy-cluster3.sh

