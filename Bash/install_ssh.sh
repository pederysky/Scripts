#!/bin/bash

# Actualizar la lista de paquetes
sudo apt update

# Instalar el servidor OpenSSH
sudo apt install -y openssh-server

# Permitir conexiones SSH en el firewall
sudo ufw allow ssh

# Mostrar el estado del servicio SSH
sudo systemctl status ssh
