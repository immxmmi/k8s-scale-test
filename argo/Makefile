SHELL := /bin/bash
.DEFAULT_GOAL := help
# ANSI Colors
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

# ANSI Colors
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m


# Global Variables
MINIKUBE_IP := localhost
PORT := 8088

help:
	@echo "═══════════════════════════════════════════════"
	@echo "🚀 Available Commands"
	@echo "═══════════════════════════════════════════════"
	@echo ""
	@echo "🔧 Required Setup:"
	@echo "  argocd_install                  ▶️  Install ArgoCD via Helm"
	@echo "  argocd_port_forward_ui          ▶️  Port-forward ArgoCD to localhost"
	@echo "  argocd_credentials              ▶️  Get ArgoCD credentials"
	@echo ""
	@echo "💻 Minikube:"
	@echo "  minikube_start                  ▶️  Start Minikube"
	@echo "  minikube_stop                   ▶️  Stop Minikube"
	@echo "  minikube_destroy                ▶️  Delete Minikube"
	@echo ""
	@echo "📘 Run 'make <command>' to execute a specific task."
	@echo "═══════════════════════════════════════════════"

# ─────────────────────────────────────────────────────────────
# 🐳 Minikube – Start, Stop, Destroy
minikube_start:
	@echo "🚀 Starting Minikube..."
	@minikube start --driver=docker --memory=4000 --cpus=3 --force

minikube_stop:
	@echo "🛑 Stopping Minikube..."
	@minikube stop

minikube_destroy:
	@echo "🗑️  Destroying Minikube..."
	@minikube delete
	@echo -e "$(GREEN)✅ Minikube has been destroyed.$(NC)"


# ─────────────────────────────────────────────────────────────
# 🧭 ArgoCD – Setup, Login & Projektanbindung
# ─────────────────────────────────────────────────────────────

argocd_install:
	@helm repo add argo https://argoproj.github.io/argo-helm
	@helm repo update
	@helm install argocd argo/argo-cd --version 8.0.7 --namespace argocd --create-namespace -f values.yaml
	@echo "Waiting for ArgoCD to be ready..."
	@kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
	@echo "ArgoCD is ready!"

argocd_credentials:
	@echo "🔐 Getting ArgoCD credentials..."
	@PASSWORD=$$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' 2>/dev/null | base64 --decode); \
	if [[ -z "$$PASSWORD" ]]; then \
	  echo "❌ Secret 'argocd-initial-admin-secret' not found. It may have been overridden via Helm values."; \
	else \
	  echo "🪪 Credentials for ArgoCD Login:"; \
	  echo "  username: admin"; \
	  echo "  password: $$PASSWORD"; \
	fi
argocd_port_forward_ui:
	@kubectl port-forward svc/argocd-server -n argocd 8088:443 > /dev/null 2>&1 &
	@echo "ArgoCD is available at http://localhost:8088/"
	@make argocd_credentials