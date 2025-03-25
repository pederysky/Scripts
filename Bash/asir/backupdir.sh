#!/bin/bash
echo "Pedro Egea Ortega 2ºX"

# Función para mostrar la ayuda
ayuda() {
    echo "Uso: backupdir.sh [opciones]"
    echo "Opciones:"
    echo "-b, --backup [directorio]   Realiza una copia de seguridad del directorio especificado"
    echo "-l, --listar                Lista todas las copias de seguridad realizadas"
    echo "-r, --restaurar [archivo]   Restaura un directorio a partir de una copia de seguridad"
    echo "-h, --help                  Muestra esta ayuda"
    exit 0
}

# Control de parámetros
if [[ $# -eq 0 ]]; then
    ayuda
fi

# Parsear opciones
while [[ $# -gt 0 ]]; do
    case "$1" in
        -b|--backup)
            directorio=$2
            if [[ -z $directorio ]]; then
                echo "Error: Debes especificar un directorio."
                exit 1
            fi
            shift 2
            if [[ ! -d $directorio ]]; then
                echo "Error: El directorio $directorio no existe."
                exit 1
            else
                # Crear backup
                timestamp=$(date +"%Y%m%d%H%M%S")
                backup_file="backup_$(basename "$directorio")_${timestamp}.tar.gz"
                tar -czf "$backup_file" -C "$(dirname "$directorio")" "$(basename "$directorio")"
                echo "Backup realizado: $backup_file"
            fi
            exit 0
            ;;

        -l|--listar)
            # Listar backups
            backups=$(ls backup_*.tar.gz 2> /dev/null)
            if [[ -z $backups ]]; then
                echo "No hay copias de seguridad disponibles."
            else
                echo "Copias de seguridad disponibles:"
                echo "$backups"
            fi
            exit 0
            ;;
        -r|--restaurar)
            backup_file=$2
            if [[ -z $backup_file ]]; then
                echo "Error: Debes especificar un archivo de backup."
                exit 1
            fi

            if [[ ! -f $backup_file ]]; then
                echo "Error: El archivo de backup $backup_file no existe."
                exit 1
            else
                # Restaurar backup
                tar -xzf "$backup_file"
                echo "Backup restaurado desde $backup_file"
            fi
            exit 0
            ;;
        -h|--help)
            ayuda
            exit 0
            ;;
        *)
            echo "Opción desconocida: $1"
            ayuda
            exit 1
            ;;
    esac
done
