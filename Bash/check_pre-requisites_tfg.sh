#!/bin/bash

echo "🔹 Docker Version:"
docker --version

echo -e "\n🔹 Docker Compose Version:"
docker compose version

echo -e "\n🔹 kubectl Client Version:"
kubectl version --client

echo -e "\n🔹 Minikube Version:"
minikube version

echo -e "\n🔹 Kubernetes Full Version (Client & Server):"
kubectl version --output=yaml
