# keda-test


docker build -t keda-demo-app .

minikube image load keda-demo-app


kubectl apply -f k8s.yaml

minikube service keda-demo -n keda-demo


## Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace prometheus --create-namespace

## KEDA isntall

helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda --namespace keda --create-namespace


# start Prometheus
minikube service prometheus-kube-prometheus-prometheus -n prometheus