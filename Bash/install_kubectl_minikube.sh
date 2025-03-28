#!/bin/bash

set -e  # Detiene el script si hay un error

K8S_VERSION="v1.30.0"  # Cambia esto cuando haya una nueva versión

echo "=== Instalando kubectl ==="
curl -LO "https://dl.k8s.io/release/$K8S_VERSION/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
echo "✅ kubectl instalado correctamente."

kubectl version --client

echo "=== Instalando Minikube ==="
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod +x /usr/local/bin/minikube
echo "✅ Minikube instalado correctamente."

minikube version

echo "=== Iniciando Minikube ==="
minikube start --driver=docker

echo "=== Verificando pods ==="
kubectl get po -A

echo "=== Guardando configuración de kubeconfig ==="
cp ~/.kube/config kubeconfig.yaml
cat kubeconfig.yaml

echo "✅ Instalación y configuración completadas."

