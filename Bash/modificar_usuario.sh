#!/bin/bash

# Verificar si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root." >&2
    exit 1
fi

# Pedir el nombre del usuario
read -p "Nombre del usuario a modificar: " USERNAME

# Verificar si el usuario existe
if ! id "$USERNAME" &>/dev/null; then
    echo "El usuario '$USERNAME' no existe." >&2
    exit 1
fi

# Verificar que el usuario no sea del sistema (UID < 1000)
USER_UID=$(id -u "$USERNAME")
if [[ "$USER_UID" -lt 1000 ]]; then
    echo "No se pueden modificar usuarios del sistema." >&2
    exit 1
fi

# Mostrar menú de opciones
echo "Selecciona una opción:"
echo "1) Cambiar contraseña"
echo "2) Agregar a un grupo"
echo "3) Eliminar de un grupo"
echo "4) Cambiar shell predeterminado"
read -p "Opción (1-4): " OPTION

case "$OPTION" in
    1)  # Cambiar contraseña
        read -s -p "Nueva contraseña: " PASSWORD
        echo
        echo "$USERNAME:$PASSWORD" | chpasswd
        echo "Contraseña cambiada con éxito."
        ;;
    
    2)  # Agregar a un grupo
        read -p "Nombre del grupo: " GROUPNAME
        if getent group "$GROUPNAME" > /dev/null; then
            usermod -aG "$GROUPNAME" "$USERNAME"
            echo "Usuario '$USERNAME' agregado al grupo '$GROUPNAME'."
        else
            echo "El grupo '$GROUPNAME' no existe." >&2
            exit 1
        fi
        ;;
    
    3)  # Eliminar de un grupo
        read -p "Nombre del grupo: " GROUPNAME
        if groups "$USERNAME" | grep -qw "$GROUPNAME"; then
            gpasswd -d "$USERNAME" "$GROUPNAME"
            echo "Usuario '$USERNAME' eliminado del grupo '$GROUPNAME'."
        else
            echo "El usuario '$USERNAME' no pertenece al grupo '$GROUPNAME'." >&2
            exit 1
        fi
        ;;
    
    4)  # Cambiar shell
        read -p "Nuevo shell (/bin/bash, /bin/zsh, etc.): " NEWSHELL
        if [[ -x "$NEWSHELL" ]]; then
            usermod -s "$NEWSHELL" "$USERNAME"
            echo "Shell cambiado a '$NEWSHELL' para el usuario '$USERNAME'."
        else
            echo "El shell '$NEWSHELL' no es válido." >&2
            exit 1
        fi
        ;;
    
    *)  # Opción no válida
        echo "Opción inválida." >&2
        exit 1
        ;;
esac

exit 0
