# Kubernetes Scale Test

Dieses Projekt dient zum Testen von automatischem Skalieren von Deployments in einem Minikube-Cluster. Zwei Ansätze werden hier verglichen:

- **KEDA** (Kubernetes Event-driven Autoscaling)
- **Knative** (Serverless Platform für Kubernetes)

## Setup

Stelle sicher, dass Minikube installiert ist. Starte anschließend den Cluster:

```bash
minikube start
```

## Build & Load Docker Image

Baue das Beispiel-Docker-Image und lade es in den Minikube-Cluster:

```bash
docker build -t dev.local/dummy-autoscale-app:latest .
minikube image load dev.local/dummy-autoscale-app:latest
```

## Varianten

- [KEDA Variante](keda/README.md): Verwendung von KEDA zum eventbasierten Skalieren.
- [Knative Variante](README.md): Serverless-Skalierung auf Basis von HTTP-Traffic.

## Ziel

Ziel ist es, das Verhalten und die Effizienz beider Skalierungsansätze unter Lastbedingungen zu vergleichen.