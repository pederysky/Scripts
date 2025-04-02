#!/bin/bash

LOGFILE="usuarios_recuperados.log"
BACKUP_DIR="/backup_usuarios"

# Verificar si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root." >&2
    exit 1
fi

# Pedir nombre de usuario
read -p "Nombre de usuario a recuperar: " USERNAME

# Buscar el backup más reciente del usuario
BACKUP_FILE=$(ls -t "$BACKUP_DIR/${USERNAME}_backup_"*.tar.gz 2>/dev/null | head -n 1)

# Verificar si hay un backup disponible
if [[ -z "$BACKUP_FILE" ]]; then
    echo "No se encontró ningún backup para el usuario '$USERNAME'." >&2
    exit 1
fi

echo "Backup encontrado: $BACKUP_FILE"

# Obtener UID anterior del usuario desde el backup
USERID=$(tar -tzf "$BACKUP_FILE" | grep -m1 "/home/$USERNAME" | awk -F/ '{print $3}' | xargs stat -c "%u" 2>/dev/null)

# Si no se pudo determinar el UID, asignar uno automáticamente
if [[ -z "$USERID" ]]; then
    USERID=1001  # UID por defecto si no se puede recuperar el original
fi

# Crear el usuario con el mismo UID si no existe
if ! id "$USERNAME" &>/dev/null; then
    echo "Creando usuario '$USERNAME' con UID $USERID..."
    useradd -m -u "$USERID" -s /bin/bash "$USERNAME"
fi

# Restaurar el home del usuario
echo "Restaurando home del usuario..."
tar -xzf "$BACKUP_FILE" -C /

# Regenerar una nueva contraseña
PASSWORD=$(openssl rand -base64 12)
echo "$USERNAME:$PASSWORD" | chpasswd

# Mostrar la información
echo "Usuario recuperado con éxito:"
echo "Usuario: $USERNAME"
echo "UID: $USERID"
echo "Nueva contraseña: $PASSWORD"

# Guardar en log
echo "$USERNAME | UID: $USERID | Recuperado el $(date)" >> "$LOGFILE"

exit 0
