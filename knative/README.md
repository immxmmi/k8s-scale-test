

## 📦 Knative Komponenten installieren

### 1. CRDs und Controller deployen

```bash
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.13.0/serving-crds.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.13.0/serving-core.yaml
```

### 2. Kourier als Ingress installieren

```bash
kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.13.0/kourier.yaml
```

### 3. Kourier als Standard-Ingress setzen

```bash
kubectl patch configmap/config-network \
  -n knative-serving \
  --type merge \
  --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'
```

## 🔍 Status prüfen

```bash
kubectl get pods -n knative-serving
kubectl get pods -n kourier-system
```

## 🚀 Anwendung deployen

```bash
kubectl apply -f k8s/
kubectl get pods -n knative-demo
```

## 🌐 Zugriff ermöglichen

Terminal für Tunnel starten:

```bash
sudo minikube tunnel
```

Knative-Service-URL anzeigen:

```bash
kubectl get ksvc knative-demo-service -n knative-demo -o jsonpath="{.status.url}"
```

Domain zu `/etc/hosts` hinzufügen (falls noch nicht vorhanden):

```bash
grep -q "knative-demo-service.knative-demo.example.com" /etc/hosts || \
echo "127.0.0.1 knative-demo-service.knative-demo.example.com" | sudo tee -a /etc/hosts > /dev/null
```

## 🌍 Domain konfigurieren

```bash
kubectl patch configmap/config-domain \
  -n knative-serving \
  --type merge \
  --patch '{"data": {"example.com": ""}}'
```

## ✅ Anwendung aufrufen

```bash
curl -H "Host: knative-demo-service.knative-demo.example.com" http://127.0.0.1
```

