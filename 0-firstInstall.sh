#!/bin/bash
#nerdctl -n k8s.io pull nginx:1.23.1-alpine
kubectl apply -f common
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo '----------'
echo $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo '----------'
kubectl apply -f ingress
