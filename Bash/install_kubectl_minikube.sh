#!/bin/bash

set -e  # Detiene el script si hay un error

K8S_VERSION="v1.30.0"  # Cambia esto cuando haya una nueva versión

# Instalación de kubectl
echo "=== Instalando kubectl ==="
curl -LO "https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
echo "✅ kubectl instalado correctamente."

kubectl version --client

# Instalación de Minikube
echo "=== Instalando Minikube ==="
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod +x /usr/local/bin/minikube
echo "✅ Minikube instalado correctamente."

minikube version

# Iniciar Minikube
echo "=== Iniciando Minikube ==="
minikube start --driver=docker

# Verificación de pods
echo "=== Verificando pods ==="
kubectl get po -A

# Guardar la configuración de kubeconfig
echo "=== Guardando configuración de kubeconfig ==="
cp ~/.kube/config kubeconfig.yaml
cat kubeconfig.yaml

# Configuración de autocompletado para kubectl en Bash
echo "=== Configurando autocompletado de kubectl en Bash ==="
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc
echo "✅ Autocompletado de kubectl habilitado en Bash."

echo "✅ Instalación y configuración completadas."

