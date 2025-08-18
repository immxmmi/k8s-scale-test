# KEDA HTTP Add-On mit Minikube installieren

Dieses Beispiel zeigt, wie du KEDA und das HTTP Add-On in einem lokalen Minikube-Cluster installierst, ein Beispiel-Deployment mit HTTP-basiertem Autoscaling erstellst und es ohne Prometheus testest.

## 1. Minikube starten und Ingress aktivieren  
➡️ Startet das lokale Kubernetes-Cluster und aktiviert den Ingress-Controller.

```bash
minikube start
minikube addons enable ingress
```

## 2. ArgoCD installieren  
➡️ Installiert ArgoCD zur Verwaltung von Kubernetes-Anwendungen via GitOps.

```bash
cd argo/
make argocd_install
make argocd_port_forward_ui
cd ..
```

## 3. cert-manager installieren  
➡️ Installiert den cert-manager zur automatischen TLS-Zertifikatserstellung für Ingress-Ressourcen.

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
```

## 4. KEDA installieren  
➡️ Installiert KEDA für das automatische Skalieren von Workloads.

```bash
export NAMESPACE=keda
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install --create-namespace -n ${NAMESPACE} keda kedacore/keda
```

## 5. HTTP Add-On installieren  
➡️ Ergänzt KEDA um HTTP-Skalierung (Anfragen triggern Pod-Skalierung).

```bash
helm install --create-namespace -n ${NAMESPACE} http-add-on kedacore/keda-add-ons-http
```

## 6. Lokale Hosts-Datei anpassen  
➡️ Stellt sicher, dass `keda-demo.local` lokal auf `127.0.0.1` zeigt (für Ingress-Zugriff im Browser).

```bash
echo "127.0.0.1 keda-demo.local" | sudo tee -a /etc/hosts
```

## 7. ArgoCD Application anwenden  
➡️ Deployt die Beispielanwendung und die KEDA HTTP Scaling-Konfiguration über ArgoCD.

```bash
cd keda-http-addon/
kubectl apply -f keda-autoscaling.yaml
cd ..
```