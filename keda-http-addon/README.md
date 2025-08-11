# KEDA HTTP Add-On mit Minikube installieren

Dieses Beispiel zeigt, wie du KEDA und das HTTP Add-On in einem lokalen Minikube-Cluster installierst, ein Beispiel-Deployment mit automatischem HTTP-basiertem Autoscaling erstellst und es ohne Prometheus testest.

## Installation

```bash
# 1. Minikube starten
minikube start --cpus=4 --memory=4096

# 2. KEDA installieren
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda -n keda --create-namespace

# 3. HTTP Add-On installieren
helm install http-add-on kedacore/keda-add-ons-http \
  -n keda \
  --create-namespace
```

## Beispiel-Deployment, Service und HTTPScaledObject

```bash
kubectl create namespace keda-demo

kubectl apply -n keda-demo -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: keda-demo
spec:
  replicas: 0
  selector:
    matchLabels:
      app: keda-demo
  template:
    metadata:
      labels:
        app: keda-demo
    spec:
      containers:
      - name: keda-demo
        image: mendhak/http-https-echo
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: keda-demo
spec:
  selector:
    app: keda-demo
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
---
apiVersion: http.keda.sh/v1alpha1
kind: HTTPScaledObject
metadata:
  name: keda-demo-scaler
spec:
  host: keda-demo.example.com
  targetPendingRequests: 5
  scaleTargetRef:
    deployment: keda-demo
    service: keda-demo
EOF
```

## Zugriff ohne Ingress

Du brauchst keinen eigenen Ingress-Controller. Der einfachste Weg:

**Option 1 – Port-Forward**
```bash
kubectl -n keda port-forward svc/keda-add-ons-http-interceptor-proxy 8080:8080
curl -H "Host: keda-demo.example.com" http://127.0.0.1:8080/
```

**Option 2 – Minikube Tunnel**
```bash
minikube tunnel
# Finde die LoadBalancer-IP des Interceptors und trage sie in /etc/hosts ein:
# <LB-IP> keda-demo.example.com
```

## Testen

```bash
kubectl -n keda-demo get deploy,po -w
hey -z 30s -H "Host: keda-demo.example.com" http://127.0.0.1:8080/
```

Damit läuft Minikube mit KEDA und dem HTTP Add-On, und dein Deployment skaliert automatisch basierend auf HTTP-Traffic – **ohne Prometheus**.



helm repo add kedacore https://kedacore.github.io/charts && helm repo update
helm install keda kedacore/keda -n keda --create-namespace
helm install http-add-on kedacore/keda-add-ons-http -n keda

kubectl -n keda port-forward svc/keda-add-ons-http-interceptor-proxy 8080:8080
curl -H "Host: keda-demo.example.com" http://127.0.0.1:8080/