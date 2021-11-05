#!/bin/bash
echo installing prometheus...

kubectl create ns prometheus

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus \
  --namespace prometheus \
  --set alertmanager.persistentVolume.storageClass="gp2" \
  --set server.persistentVolume.storageClass="gp2" \
  --values ./prometheus.values.yaml

kubectl expose deployment prometheus-server \
  --namespace prometheus \
  --name=prometheus-server-loadbalancer \
  --type=LoadBalancer \
  --port=80 \
  --target-port=9090

echo "waiting for prometheus to start (1-2mins)..."
kubectl wait --for=condition=available --timeout=300s deployment/prometheus-alertmanager -n prometheus
kubectl wait --for=condition=available --timeout=300s deployment/prometheus-kube-state-metrics -n prometheus
kubectl wait --for=condition=available --timeout=300s deployment/prometheus-pushgateway -n prometheus
kubectl wait --for=condition=available --timeout=300s deployment/prometheus-server -n prometheus

kubectl get all -n prometheus

echo prometheus install finished!
