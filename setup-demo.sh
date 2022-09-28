#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will run the the demo of Istio Mutlt-cluster with SPIRE and OPA        #"
echo -e "########################################################################################"
read -p "Press any key to begin"

. ./0-setup.sh

./1-deploy-clusters.sh cluster1
./1-deploy-clusters.sh cluster2
./1-deploy-clusters.sh cluster3

./2-install-istio.sh cluster1
./2-install-istio.sh cluster1
./2-install-istio.sh cluster1

./3-enable-istio-multicluster.sh

./4-install-kiali.sh cluster1

./5-install-styra.sh cluster1
./5-install-styra.sh cluster2
./5-install-styra.sh cluster3