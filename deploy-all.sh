#/bin/bash

# https://antonputra.com/amazon/create-eks-cluster-using-eksctl/#create-private-eks-cluster-using-eksctl

#eksctl create cluster --name aws-c1 --nodes 2 --profile adfs
#eksctl create cluster --name google-c1 --nodes 2 --profile adfs

eksctl delete cluster --name=aws-cluster --profile adfs
eksctl delete cluster --name=google-cluster --profile adfs

# go the the console and create a VNC + go to each subnet which got created and edit it allow provide ipv4 address by default

eksctl create cluster -f cluster-aws.yaml --profile adfs
eksctl create cluster -f cluster-google.yaml --profile adfs

# eksctl create nodegroup \
#  --cluster my-cluster \
#  --region region-code \
#  --name my-mng \
#  --node-type m5.large \
#  --nodes 3 \
#  --nodes-min 2 \
#  --nodes-max 4 \
#  --ssh-access \
#  --ssh-public-key my-key


CLUSTER1=V710894@aws-cluster.us-east-1.eksctl.io
CLUSTER2=V710894@google-cluster.us-east-1.eksctl.io

kubectl config use-context $CLUSTER1

#kubectl create ns istio-system
#kubectl create ns spire
#sleep 1
#kubectl apply -f empty-cm.yaml

# udpate server-configmap-aws.yaml with the right IPS and  open security between clusters

kubectl create ns istio-system
kubectl create ns spire
kubectl apply -f ./configmaps.yaml

(cd spire ; ./deploy-spire-domain-aws.sh)

kubectl -n spire rollout status statefulset spire-server
kubectl -n spire rollout status daemonset spire-agent

aws_bundle=$(kubectl exec --stdin spire-server-0 -c spire-server -n spire  -- /opt/spire/bin/spire-server bundle show -format spiffe -socketPath /run/spire/sockets/server.sock)

kubectl config use-context $CLUSTER2

#kubectl create ns istio-system
#kubectl create ns spire
#sleep 1
#kubectl apply -f empty-cm.yaml

kubectl create ns istio-system
kubectl create ns spire
kubectl apply -f ./configmaps.yaml

(cd spire ; ./deploy-spire-domain-google.sh)

kubectl -n spire rollout status statefulset spire-server
kubectl -n spire rollout status daemonset spire-agent

google_bundle=$(kubectl exec --stdin spire-server-0 -c spire-server -n spire  -- /opt/spire/bin/spire-server bundle show -format spiffe -socketPath /run/spire/sockets/server.sock)

# Set example.org bundle to domain.test SPIRE bundle endpoint
kubectl exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server  bundle set -format spiffe -id spiffe://aws.com -socketPath /run/spire/sockets/server.sock <<< "$aws_bundle"

### move to cluster 1
kubectl config use-context $CLUSTER1

# Set domain.test bundle to example.org SPIRE bundle endpoint
kubectl exec --stdin spire-server-0 -c spire-server -n spire -- /opt/spire/bin/spire-server  bundle set -format spiffe -id spiffe://google.com -socketPath /run/spire/sockets/server.sock <<< "$google_bundle"

kubectl config use-context $CLUSTER2

######################
# ISTIO
#####################



kubectl config use-context $CLUSTER1
#kubectl create ns istio-system
#kubectl create ns sample
#kubectl apply -f ../helloworld/istio-empty-cm.yaml
(cd istio ; ./deploy-istio-aws.sh)


kubectl config use-context $CLUSTER2
#kubectl create ns istio-system
#kubectl create ns sample
#kubectl apply -f ../helloworld/istio-empty-cm.yaml

(cd istio ; ./deploy-istio-google.sh)

istioctl x create-remote-secret --context="${CLUSTER1}" --name=aws-cluster | kubectl apply -f - --context="${CLUSTER2}"

istioctl x create-remote-secret --context="${CLUSTER2}" --name=googel-cluster | kubectl apply -f - --context="${CLUSTER1}"


######################
# verify
#####################

kubectl create --context="${CLUSTER1}" namespace sample
kubectl create --context="${CLUSTER2}" namespace sample

kubectl label --context="${CLUSTER1}" namespace sample \
    istio-injection=enabled
kubectl label --context="${CLUSTER2}" namespace sample \
    istio-injection=enabled

kubectl apply --context="${CLUSTER1}" \
    -f helloworld/helloworld.yaml \
    -l service=helloworld -n sample
kubectl apply --context="${CLUSTER2}" \
    -f helloworld/helloworld.yaml \
    -l service=helloworld -n sample

kubectl apply --context="${CLUSTER1}" \
    -f helloworld/helloworld.yaml \
    -l version=v1 -n sample

kubectl get pod --context="${CLUSTER1}" -n sample -l app=helloworld -w

kubectl apply --context="${CLUSTER2}" \
    -f helloworld/helloworld.yaml \
    -l version=v2 -n sample

kubectl get pod --context="${CLUSTER2}" -n sample -l app=helloworld -w


kubectl apply --context="${CLUSTER1}" \
    -f helloworld/sleep.yaml -n sample
kubectl apply --context="${CLUSTER2}" \
    -f helloworld/sleep.yaml -n sample


kubectl get pod --context="${CLUSTER1}" -n sample -l app=sleep

kubectl get pod --context="${CLUSTER2}" -n sample -l app=sleep

#### testing now

kubectl exec --context="${CLUSTER1}" -n sample -c sleep \
    "$(kubectl get pod --context="${CLUSTER1}" -n sample -l \
    app=sleep -o jsonpath='{.items[0].metadata.name}')" \
    -- curl -sS helloworld.sample:5000/hello

kubectl exec --context="${CLUSTER2}" -n sample -c sleep \
    "$(kubectl get pod --context="${CLUSTER2}" -n sample -l \
    app=sleep -o jsonpath='{.items[0].metadata.name}')" \
    -- curl -sS helloworld.sample:5000/hello


