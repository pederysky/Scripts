#!/bin/bash

OUTPUT_FILE="usuarios_listado.csv"

# Verificar si el script se ejecuta como root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root." >&2
    exit 1
fi

# Preguntar cómo ordenar la lista
echo "Selecciona el criterio de ordenación:"
echo "1) Por nombre de usuario"
echo "2) Por UID"
read -p "Opción (1/2): " OPTION

# Construir el comando de ordenación
SORT_OPTION=""
case "$OPTION" in
    1) SORT_OPTION="sort -t: -k1" ;;  # Ordenar por nombre
    2) SORT_OPTION="sort -t: -k3 -n" ;;  # Ordenar por UID
    *) echo "Opción inválida, usando orden por nombre."; SORT_OPTION="sort -t: -k1" ;;
esac

# Encabezado del archivo CSV
echo "Nombre de Usuario,UID,GID,Directorio Home,Shell" > "$OUTPUT_FILE"

# Listar usuarios y aplicar filtro y ordenación
awk -F: '$3 >= 1000 {print $1","$3","$4","$6","$7}' /etc/passwd | eval "$SORT_OPTION" >> "$OUTPUT_FILE"

# Mostrar la lista en pantalla
column -s, -t "$OUTPUT_FILE"

echo "Lista de usuarios guardada en: $OUTPUT_FILE"

exit 0
