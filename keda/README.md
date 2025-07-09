# 🚀 KEDA Autoscaling Demo with Prometheus

This project demonstrates how to automatically scale a Kubernetes deployment using **KEDA** and **Prometheus** – including scale-to-zero when there is no load.

## 🔧 Prerequisites
- Kubernetes (e.g., via Minikube)
- Helm installed
- `kubectl` access to your cluster

## 📦 Installation

### 1. Install Prometheus
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace prometheus --create-namespace
```

### 2. Install KEDA
```bash
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda --namespace keda --create-namespace
```

## 📊 Start Prometheus UI
```bash
minikube service prometheus-kube-prometheus-prometheus -n prometheus
```

## ⚙️ Deploy KEDA application
```bash
kubectl apply -f k8s.yaml
minikube service keda-demo -n keda-demo
```

## 🔍 Check metrics
```bash
kubectl port-forward svc/keda-demo -n keda-demo 8080:80 >/dev/null 2>&1 &
curl -s http://localhost:8080/metrics | grep http_requests_total
```

## ✅ Goal
The deployment is automatically scaled – including **scale-to-zero** when no HTTP requests are incoming.