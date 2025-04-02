#!/bin/bash

LOGFILE="usuarios_creados.log"

# Verificar si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root." >&2
    exit 1
fi

# Pedir datos al usuario
read -p "Nombre de usuario: " USERNAME
read -p "UID (Número de usuario): " USERID
read -p "Grupo: " GROUPNAME

# Verificar si el grupo existe; si no, crearlo
if ! getent group "$GROUPNAME" > /dev/null; then
    echo "El grupo '$GROUPNAME' no existe. Creándolo..."
    groupadd "$GROUPNAME"
fi

# Verificar si el usuario ya existe
if id "$USERNAME" &>/dev/null; then
    echo "El usuario '$USERNAME' ya existe." >&2
    exit 1
fi

# Crear el usuario con UID y asignarlo al grupo
useradd -m -u "$USERID" -g "$GROUPNAME" -s /bin/bash "$USERNAME"

# Generar una contraseña aleatoria
PASSWORD=$(openssl rand -base64 12)
echo "$USERNAME:$PASSWORD" | chpasswd

# Mostrar los datos del usuario
echo "Usuario creado con éxito:"
echo "Usuario: $USERNAME"
echo "UID: $USERID"
echo "Grupo: $GROUPNAME"
echo "Contraseña: $PASSWORD"

# Guardar en log
echo "$USERNAME | UID: $USERID | Grupo: $GROUPNAME | $(date)" >> "$LOGFILE"

exit 0
