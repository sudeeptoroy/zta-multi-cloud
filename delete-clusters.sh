#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will delete Isio multi-cluster                                        #"
echo -e "########################################################################################"
read -p "Press any key to begin"

eksctl delete cluster --name=cluster1
eksctl delete cluster --name=cluster2
eksctl delete cluster --name=cluster3