#!/bin/bash
#nerdctl -n k8s.io pull nginx:1.23.1-alpine
kubectl create namespace longhorn-system
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.3.2/deploy/longhorn.yaml
