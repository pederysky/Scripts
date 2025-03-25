#!/bin/bash
echo "Pedro Egea Ortega 2ºX"

# Función para mostrar la ayuda
ayuda() {
    echo "Uso: gestionarch.sh [opciones]"
    echo "Opciones:"
    echo "-f, --file [archivo]   Especifica el archivo a gestionar"
    echo "-h, --help             Muestra esta ayuda"
    exit 1
}

# Función para mostrar el menú
menu() {
    echo "Elige una opción para gestionar el archivo $(basename $archivo):"
    echo "1) Mover"
    echo "2) Renombrar"
    echo "3) Eliminar"
    echo "4) Mostrar información"
    echo "5) Salir"
    read -p "Opción: " opcion
}

# Control de parámetros
if [[ $# -eq 0 ]]; then
    ayuda
else
    if [[ $1 = "-h" || $1 = "--help" ]]; then
        ayuda
        exit 1
    elif [[ $1 = "-f" || $1 = "--file" ]]; then
        archivo="$2"
        if [[ ! -f $archivo ]]; then
            echo "Error: El archivo $archivo no existe."
            exit 1
        fi
    else
        echo "Opción desconocida: $1"
        ayuda
        exit 1
    fi
fi


    


# Lógica de programa
while true; do
    menu
    case $opcion in
        1)
            read -p "Introduce la nueva ruta para mover el archivo: " nueva_ruta
            if [[ ! -d $nueva_ruta ]]; then
                read -p "La ruta no existe. ¿Deseas crearla? (s/n) " crear
                if [[ $crear == "s" ]]; then
                    mkdir -p "$nueva_ruta"
                    echo "Directorio creado."
                else
                    echo "Operación cancelada."
                    continue
                fi
            fi
            mv "$archivo" "$nueva_ruta/"
            archivo="$nueva_ruta/$(basename "$archivo")"
            echo "Archivo movido a $archivo"
            ;;
        2)
            read -p "Introduce el nuevo nombre para el archivo: " nuevo_nombre
            mv "$archivo" "$(dirname "$archivo")/$nuevo_nombre"
            archivo="$(dirname "$archivo")/$nuevo_nombre"
            echo "Archivo renombrado a $archivo"
            ;;
        3)
            read -p "¿Estás seguro de que quieres eliminar $archivo? (s/n) " confirmacion
            if [[ $confirmacion == "s" ]]; then
                rm "$archivo"
                echo "Archivo eliminado."
                exit 1
            else
                echo "Operación cancelada."
            fi
            ;;
        4)
            echo "Información del archivo $(basename $archivo):"
            echo "Tamaño: $(stat -c%s "$archivo") bytes"
            echo "Fecha de creación: $(stat -c%y "$archivo" | cut -d '.' -f1)"
            echo "Permisos: $(stat -c%A "$archivo")"
            exit 1
            ;;
        5)
            echo "Saliendo..."
            exit 1
            ;;
        *)
            echo "Opción no válida, por favor elige de nuevo."
            ;;
    esac
done
