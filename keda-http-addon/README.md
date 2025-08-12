# KEDA HTTP Add-On mit Minikube installieren

Dieses Beispiel zeigt, wie du KEDA und das HTTP Add-On in einem lokalen Minikube-Cluster installierst, ein Beispiel-Deployment mit automatischem HTTP-basiertem Autoscaling erstellst und es ohne Prometheus testest.

## Installation

```bash
# 1. Minikube starten
minikube start --cpus=4 --memory=4096
## ingress aktivern

minikube addons enable ingress

# 2. ArgoCD
argo/
make argocd_install
make argocd_port_forward_ui

# 3. KEDA installieren
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda -n keda --create-namespace

# 4. HTTP Add-On installieren
helm install http-add-on kedacore/keda-add-ons-http -n keda

# 5. Add Docker image to minikube
cd apps/test-app
docker build -t dev.local/dummy-autoscale-app:latest .
minikube image load dev.local/dummy-autoscale-app:latest

# 6. Install Argocd Applicaion
cd keda-http-addon/keda-autoscaling.yaml