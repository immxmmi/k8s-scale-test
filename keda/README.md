# 🚀 KEDA Autoscaling Demo mit Prometheus

Dieses Projekt demonstriert, wie ein Kubernetes Deployment mithilfe von **KEDA** und **Prometheus** automatisch skaliert werden kann – inklusive **Scale-to-Zero**, wenn keine Last vorhanden ist.

## 🔧 Voraussetzungen

- Kubernetes (z. B. über Minikube)
- Helm installiert
- `kubectl` Zugriff auf den Cluster

## 📦 Installation

### 1. Prometheus installieren

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace prometheus --create-namespace
```

### 2. KEDA installieren

```bash
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda --namespace keda --create-namespace
```

## 📊 Prometheus UI starten

```bash
minikube service prometheus-kube-prometheus-prometheus -n prometheus
```

## ⚙️ KEDA-Anwendung deployen

```bash
kubectl apply -f ./k8s
minikube service keda-demo -n keda-demo
```

## 🔍 Metriken überprüfen

```bash
kubectl port-forward svc/keda-demo -n keda-demo 8080:80 >/dev/null 2>&1 &
curl -s http://localhost:8080/metrics | grep http_requests_total
```

## ✅ Ziel
Das Deployment wird automatisch hoch- und herunterskaliert – inklusive vollständigem **Herunterskalieren auf Null**, wenn keine HTTP-Anfragen eingehen.

> ❗ **Hinweis:** Um tatsächlich auf **Null Pods** skalieren zu können, muss sichergestellt werden, dass Metriken auch dann verfügbar bleiben, wenn keine Pods der Anwendung laufen. 
> 
> Wenn die Anwendung selbst die Metriken liefert, können diese bei `0` Pods nicht mehr abgefragt werden. Eine mögliche Lösung wäre ein Sidecar oder ein separater Metrik-Exporter, der dauerhaft läuft – etwa ein NGINX-Proxy, der den Traffic beobachtet und Metriken bereitstellt, da dieser unabhängig von der Anwendung aktiv bleibt.