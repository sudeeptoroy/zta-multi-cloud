read -p "Press any key to begin"

# Create test namespace
kubectl create --context="${CLUSTER1}" namespace online-boutique
kubectl create --context="${CLUSTER2}" namespace online-boutique
read -p "Press any key to continue"


# Enable Istio on namespaces
kubectl label --context="${CLUSTER1}" namespace online-boutique istio-injection=enabled
kubectl label --context="${CLUSTER2}" namespace online-boutique istio-injection=enabled
read -p "Press any key to continue"


kubectl apply --context="${CLUSTER1}" -f ./online-boutique/  -n online-boutique
kubectl apply --context="${CLUSTER2}" -f ./online-boutique/  -n online-boutique
read -p "Press any key to continue"

INGRESS_HOST="$(kubectl --context="${CLUSTER1}" -n istio-system get service istio-ingressgateway \
   -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
echo "$INGRESS_HOST"

curl -v "http://$INGRESS_HOST"

