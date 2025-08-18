# KEDA HTTP Add-On mit Minikube installieren

Dieses Beispiel zeigt, wie du KEDA und das HTTP Add-On in einem lokalen Minikube-Cluster installierst, ein Beispiel-Deployment mit automatischem HTTP-basiertem Autoscaling erstellst und es ohne Prometheus testest.

## Installation

```bash
# 1. Minikube starten
minikube start
## ingress aktivern
minikube addons enable ingress

# 2. ArgoCD
cd argo/
make argocd_install
make argocd_port_forward_ui
cd ..

# 2.1. cert-manager installieren
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml

# 3. KEDA installieren
export NAMESPACE=keda
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install --create-namespace -n ${NAMESPACE} keda kedacore/keda

# 4. HTTP Add-On installieren
helm install --create-namespace -n ${NAMESPACE} http-add-on kedacore/keda-add-ons-http


echo "127.0.0.1 keda-demo.local" | sudo tee -a /etc/hosts


# 6. Install Argocd Applicaion
cd keda-http-addon/
kubectl apply -f keda-autoscaling.yaml
cd ..

# TEST
kubectl port-forward -n keda svc/keda-add-ons-http-interceptor-proxy 8080:8080
curl -H "Host: keda-demo.example.com" http://localhost:8080

hey -z 30s -c 20 -host "keda-demo.example.com" http://localhost:8080/

# Scaling beobachten
kubectl -n keda-demo get hpa,pods -w