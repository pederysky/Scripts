#!/bin/bash

# Descargar Docker Compose
echo "Descargando Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Dar permisos de ejecución
echo "Otorgando permisos de ejecución a Docker Compose..."
sudo chmod +x /usr/local/bin/docker-compose

# Verificar si jq está instalado
if ! command -v jq &> /dev/null
then
    echo "jq no encontrado, instalando..."
    sudo apt install jq -y
else
    echo "jq ya está instalado."
fi

# Descargar y habilitar autocompletado para Docker Compose
echo "Habilitando autocompletado para Docker Compose..."
sudo curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

# Descargar y habilitar autocompletado para Docker
echo "Habilitando autocompletado para Docker..."
sudo curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker -o /etc/bash_completion.d/docker

# Recargar la configuración de bash
echo "Recargando la configuración de bash..."
source ~/.bashrc

# Verificar la instalación de Docker Compose
echo "Verificando la instalación de Docker Compose..."
docker-compose --version
