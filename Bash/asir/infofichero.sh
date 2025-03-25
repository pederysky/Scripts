#!/bin/bash

# Nombre: Pedro Egea Ortega 1ºX

# Función para mostrar la ayuda
ayuda() {
    echo "Uso: infofichero.sh [–r ruta_del_fichero] [–n nombre_del_fichero]"
    echo "    o: infofichero.sh [–n nombre_del_fichero] [–r ruta_del_fichero]"
    echo "Opciones:"
    echo "  -r  Ruta del fichero"
    echo "  -n  Nombre del fichero"
}

# Función para comprobar la existencia del fichero
existe_fichero() {
    if [[ -f "$1" ]]; then
        return 0
    else
        echo "Error: El fichero '$1' no existe."
        exit 1
    fi
}

ruta=""
nombre=""

# Comprobar parámetros
if [[ $# -eq 1 ]] || [[ $# -eq 3 ]] || [[ $# -gt 4 ]]; then
    echo "Parámetros incorrectos"
    ayuda
    exit 1
else
    if [[ $# -eq 4 ]]; then
        if [[ $1 = -r ]] && [[ $3 = -n ]];then
            ruta="$2"
            nombre="$4"
        elif [[ $1 = -n ]] && [[ $3 = -r ]];then
            ruta="$4"
            nombre="$2"
        else
            echo "Parámetros incorrectos"
            ayuda
            exit 1
        fi
    elif [[ $# -eq 2 ]]; then
        if [[ $1 = -r ]]; then
            ruta="$2"
        elif [[ $1 = -n ]]; then
            nombre="$2"
        else
            echo "Opción inválida: $1"
            ayuda
            exit 1
                
        fi
    fi
fi
# Solicitar parámetros faltantes
if [[ -z "$ruta" ]]; then
    read -p "Introduzca la ruta del fichero: " ruta
fi

if [[ -z "$nombre" ]]; then
    read -p "Introduzca el nombre del fichero: " nombre
fi

# Comprobar existencia del fichero
fichero="${ruta}/${nombre}"
existe_fichero "$fichero"

# Menú de opciones
opcion=0
while [[ $opcion -ne 4 ]]; do
    echo ""
    echo "1) Mostrar"
    echo "2) Copiar"
    echo "3) Permisos"
    echo "4) Salir"
    read -p "Seleccione una opción: " opcion
    echo ""

    case $opcion in
        1)
            cat "$fichero"
            ;;
        2)
            read -p "Introduzca el directorio destino: " destino
            if [[ ! -d "$destino" ]]; then
                read -p "El directorio no existe. ¿Desea crearlo? (s/n): " crear
                while [[ "$crear" != "s" && "$crear" != "n" ]]; do
                    read -p "Opción inválida. Escribe (s/n): " crear
                    if [[ "$crear" == "s" ]]; then
                        mkdir -p "$destino"
                        echo "Directorio creado correctamente"
                    else
                        continue
                    fi
                done
            fi
            destino_fichero="${destino}/${nombre}"
            if [[ -f "$destino_fichero" ]]; then
                echo "El fichero ya existe en el directorio destino."
                read -p "¿Sobrescribir (s), añadir (a), cancelar (c)?: " decision
                case $decision in
                    s)
                        cp "$fichero" "$destino_fichero"
                        ;;
                    a)
                        cat "$fichero" >> "$destino_fichero"
                        ;;
                    c)
                        continue
                        ;;
                    *)
                        echo "Opción inválida."
                        continue
                        ;;
                esac
            else
                cp "$fichero" "$destino_fichero"
            fi
            ;;
        3)
            permisos=$(ls -l "$fichero" | cut -d ' ' -f 1)
            echo "Permisos: $permisos"
            ;;
        4)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "No es una opción válida."
            ;;
    esac
done
