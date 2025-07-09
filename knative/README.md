
# CRDs und Controller
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.13.0/serving-crds.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.13.0/serving-core.yaml

# Kourier als Ingress
kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.13.0/kourier.yaml

# Kourier als Standard-Ingress setzen
kubectl patch configmap/config-network \
  -n knative-serving \
  --type merge \
  --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'


# CHECK
kubectl get pods -n knative-serving
kubectl get pods -n kourier-system

# Apply
kubectl apply -f k8s/
kubectl get pods -n knative-demo

sudo minikube tunnel
kubectl get ksvc knative-demo-service -n knative-demo -o jsonpath="{.status.url}"

grep -q "knative-demo-service.knative-demo.example.com" /etc/hosts || \
echo "127.0.0.1 knative-demo-service.knative-demo.example.com" | sudo tee -a /etc/hosts > /dev/null

kubectl patch configmap/config-domain \
  -n knative-serving \
  --type merge \
  --patch '{"data": {"example.com": ""}}'

curl -H "Host: knative-demo-service.knative-demo.example.com" http://127.0.0.1

