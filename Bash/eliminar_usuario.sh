#!/bin/bash

LOGFILE="usuarios_eliminados.log"
BACKUP_DIR="/backup_usuarios"

# Verificar si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root." >&2
    exit 1
fi

# Pedir nombre de usuario
read -p "Nombre de usuario a eliminar: " USERNAME

# Verificar si el usuario existe
if ! id "$USERNAME" &>/dev/null; then
    echo "El usuario '$USERNAME' no existe." >&2
    exit 1
fi

# Crear el directorio de backup si no existe
mkdir -p "$BACKUP_DIR"

# Hacer backup del home del usuario
USER_HOME="/home/$USERNAME"
if [ -d "$USER_HOME" ]; then
    echo "Creando backup del home de $USERNAME..."
    tar -czf "$BACKUP_DIR/${USERNAME}_backup_$(date +%F).tar.gz" "$USER_HOME"
    echo "Backup guardado en: $BACKUP_DIR/${USERNAME}_backup_$(date +%F).tar.gz"
fi

# Confirmar eliminación
read -p "¿Quieres eliminar el usuario '$USERNAME'? (s/n): " CONFIRM
if [[ "$CONFIRM" != "s" ]]; then
    echo "Eliminación cancelada."
    exit 1
fi

# Eliminar el usuario y su home
userdel -r "$USERNAME"

# Registrar la eliminación
echo "$USERNAME eliminado el $(date)" >> "$LOGFILE"

echo "Usuario '$USERNAME' eliminado con éxito."
exit 0
