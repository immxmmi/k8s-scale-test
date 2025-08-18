```bash
# 1. Minikube starten
minikube start
## ingress aktivern
minikube addons enable ingress

echo "127.0.0.1 my-app.local" | sudo tee -a /etc/hosts

minikube tunnel
````
