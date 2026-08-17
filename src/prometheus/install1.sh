#!/bin/bash

if kubectl get ns | grep -q "^prometheus"; then
  echo "Skipping installation of prometheus because namespace already exists"
  echo "If you want to reinstall execute: "
  echo "'kubectl delete ns prometheus'"
  exit 1
else

if ! helm repo list | grep -q "^prometheus-community"; then
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update prometheus-community
fi

echo "Install prometheus"
kubectl create namespace prometheus

# DON'T create PV/PVC - let the StorageClass handle it
# envsubst < create-storage.yaml | kubectl apply -f -

helm install prometheus -n prometheus --version=27.1.0   --set alertmanager.enabled=false   --set pushgateway.enabled=false   --set server.persistentVolume.enabled=true   --set server.persistentVolume.storageClass=managed-nfs-storage   --set server.persistentVolume.size=10Gi   prometheus-community/prometheus

echo "Installation done prometheus"

# Ingress
cat << EOF | envsubst | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-prometheus
  namespace: prometheus
spec:
  ingressClassName: nginx
  rules:
    - host: prometheus.piincus.homekube.org
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus-server
                port:
                  number: 80
EOF
echo "Installation done prometheus"
fi
