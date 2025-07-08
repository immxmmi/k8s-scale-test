
# ARGOCD Cluster
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --version 8.0.16 --namespace argocd --create-namespace -f values.yaml



# Argo CD Setup mit Makefile

Dieses Verzeichnis enthält ein Makefile für die einfache Verwaltung von Argo CD und Minikube.

## 🚀 Setup-Befehle

### 🔧 Argo CD installieren

```bash
make argocd_install
```

Installiert Argo CD via Helm in den Namespace `argocd` und wartet auf ein erfolgreiches Deployment.

### 🔐 Argo CD Zugangsdaten anzeigen

```bash
make argocd_credentials
```

Zeigt den initialen Benutzernamen und das Passwort von Argo CD an (`admin`/`<password>`).

### 🌐 Argo CD UI lokal öffnen

```bash
make argocd_port_forward_ui
```

Startet Port-Forwarding auf `http://localhost:8088` und zeigt die Zugangsdaten an.

## 💻 Minikube-Befehle

### Starten

```bash
make minikube_start
```

### Stoppen

```bash
make minikube_stop
```

### Löschen

```bash
make minikube_destroy
```

---

> 📘 Verwende `make help` für eine Übersicht aller verfügbaren Befehle.