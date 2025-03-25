#!/bin/bash

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update
sudo apt upgrade -y

# Instalar dependencias necesarias
echo "Instalando dependencias..."
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Agregar la clave GPG oficial de Docker
echo "Agregando la clave GPG de Docker..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Agregar el repositorio de Docker
echo "Agregando el repositorio de Docker..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizar los repositorios
echo "Actualizando los repositorios..."
sudo apt update

# Instalar Docker
echo "Instalando Docker..."
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Agregar el usuario al grupo docker (opcional)
echo "Agregando el usuario al grupo docker..."
sudo usermod -aG docker $USER

# Verificar el estado de Docker
echo "Verificando el estado de Docker..."
sudo systemctl status docker
