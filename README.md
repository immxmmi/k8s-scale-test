# keda-test


docker build -t keda-demo-app .

minikube image load keda-demo-app


kubectl apply -f k8s.yaml

minikube service keda-demo -n keda-demo


## KEDA isntall

helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda --namespace keda --create-namespace