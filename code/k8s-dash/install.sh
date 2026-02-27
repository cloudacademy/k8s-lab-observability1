#!/bin/bash
echo installing k8s dashboard...

kubectl create ns k8sdash

helm repo add k8s-dashboard https://kubernetes-retired.github.io/dashboard
helm repo update

helm install k8s-dashboard k8s-dashboard/kubernetes-dashboard \
  --namespace k8sdash \
  --set=protocolHttp=true \
  --set=serviceAccount.create=true \
  --set=serviceAccount.name=k8sdash-serviceaccount \
  --version 5.0.4

echo apply k8s dashboard permissions...
#very permissive, do not use in production
kubectl create clusterrolebinding kubernetes-dashboard \
  --clusterrole=cluster-admin \ 
  --serviceaccount=k8sdash:k8sdash-serviceaccount

kubectl expose deployment k8s-dashboard-kubernetes-dashboard \
  --namespace k8sdash \
  --name=k8sdash-loadbalancer \
  --type=LoadBalancer \
  --port=80 \
  --target-port=9090

echo "waiting for k8s dashboard to start (30-60secs)..."
kubectl wait --for=condition=available --timeout=300s deployment/k8s-dashboard-kubernetes-dashboard -n k8sdash

kubectl get all -n k8sdash
kubectl get ep -n k8sdash

echo k8s dashboard install finished!
