# KEDA HTTP Add-On mit Minikube installieren

Dieses Beispiel zeigt, wie du KEDA und das HTTP Add-On in einem lokalen Minikube-Cluster installierst, ein Beispiel-Deployment mit automatischem HTTP-basiertem Autoscaling erstellst und es ohne Prometheus testest.

## Installation

```bash
# 1. Minikube starten
minikube start --cpus=4 --memory=4096
## ingress aktivern
minikube addons enable ingress

# 2. ArgoCD
cd argo/
make argocd_install
make argocd_port_forward_ui
cd ..

# 3. KEDA installieren
export NAMESPACE=keda
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install --create-namespace -n ${NAMESPACE} keda kedacore/keda

# 4. HTTP Add-On installieren
helm install --create-namespace -n ${NAMESPACE} http-add-on kedacore/keda-add-ons-http




# 5. Add Docker image to minikube
cd apps/test-app
docker build -t dev.local/dummy-autoscale-app:latest .
minikube image load dev.local/dummy-autoscale-app:latest
cd ..
cd ..

# 6. Install Argocd Applicaion
cd keda-http-addon/
kubectl apply -f keda-autoscaling.yaml
cd ..


# Host auf Minikube-IP mappen (oder -H 'Host:...' verwenden)
MINIKUBE_IP=$(minikube ip)
echo "$MINIKUBE_IP keda-demo.example.com" | sudo tee -a /etc/hosts


kubectl port-forward -n keda svc/keda-add-ons-http-interceptor-proxy 8080:8080
 



# Test-Traffic senden (löst Scaling aus)
hey -z 30s -c 20 http://keda-demo.example.com/    # oder:
curl -v -H 'Host: keda-demo.example.com' http://$MINIKUBE_IP/

# Scaling beobachten
kubectl -n keda-demo get hpa,pods -w