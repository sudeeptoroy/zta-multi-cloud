#!/bin/bash

echo -e "########################################################################################"
echo -e "#   This script will setup the environment variables for the demo"
echo -e "#      To run and update environment variables:"
echo -e "#          . ./0-setup.sh"
echo -e "########################################################################################"

# Export variables
export CLUSTER1=cluster1
export CLUSTER2=cluster2

# Set the namespaces we will use
export NS0=99995-990005-1001-dev
export NS1=99995-990005-1002-dev
export NS2=99995-990005-1003-dev
export NS3=99992-990002-1002-dev
export NS4=99996-990006-1002-dev
export NS5=99997-990007-1002-dev
export NS6=99998-990008-1002-dev
export NS7=99990-900002-9002-dev
