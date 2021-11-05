#!/bin/bash
echo installing grafana...

kubectl create ns grafana

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install grafana grafana/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword="EKS:l3t5g0" \
    --set service.type=LoadBalancer \
    --values ./grafana.values.yaml

echo "waiting for grafana to start (30-60secs)..."
kubectl wait --for=condition=available --timeout=300s deployment/grafana -n grafana

kubectl get all -n grafana

echo grafana install finished!
