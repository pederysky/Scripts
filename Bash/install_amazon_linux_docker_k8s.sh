#!/bin/bash
set -e

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo yum update -y

# Instalar Docker
echo "Instalando Docker..."
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Instalar Docker Compose
echo "Instalando Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "Docker Compose instalado: $(docker-compose --version)"

# Instalar kubectl
echo "Instalando kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl
echo "kubectl instalado: $(kubectl version --client --short)"

# Instalar Minikube
echo "Instalando Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64
echo "Minikube instalado: $(minikube version)"

# Agregar usuario al grupo docker (necesario para Minikube)
sudo usermod -aG docker $(whoami)

# Reiniciar la sesión para aplicar los cambios
echo "Instalación completada. Reinicia la sesión o ejecuta 'newgrp docker' para aplicar los cambios."
