
echo "CLUSTER1 = ${CLUSTER1}\n CLUSTER2 = ${CLUSTER2}\n"

NS="online-boutique"

read -p "Press any key to begin"

# Create test namespace
kubectl create --context="${CLUSTER1}" namespace $NS
kubectl create --context="${CLUSTER2}" namespace $NS
read -p "Press any key to continue"


# Deploy application
kubectl apply --context="${CLUSTER1}" -f ./online-boutique/kubernetes-manifest.yaml  -n $NS
kubectl apply --context="${CLUSTER2}" -f ./online-boutique/kubernetes-manifest.yaml  -n $NS
read -p "Press any key to continue"

kubectl -n online-boutique get pod -w --context=$CLUSTER1
kubectl -n online-boutique get pod -w --context=$CLUSTER2

# Enable Istio on namespaces
kubectl label --context="${CLUSTER1}" namespace $NS istio-injection=enabled --overwrite
kubectl label --context="${CLUSTER2}" namespace $NS istio-injection=enabled --overwrite
read -p "Press any key to continue"

# Configure Istio
kubectl apply --context="${CLUSTER1}" -f ./online-boutique/istio-manifest.yaml  -n $NS
kubectl apply --context="${CLUSTER2}" -f ./online-boutique/istio-manifest.yaml  -n $NS
read -p "Press any key to continue"

INGRESS_HOST="$(kubectl --context="${CLUSTER1}" -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"

echo "$INGRESS_HOST"

curl -v "http://$INGRESS_HOST"

#kubectl -n online-boutique  port-forward deployment/frontend 8080:8080
# localhost:8080
