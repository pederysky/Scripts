#!/bin/bash

# Nombre: Pedro Egea Ortega 1ºX

# Función para mostrar ayuda
function mostrar_ayuda {
    echo "Uso: infouser.sh [usuario]"
}

# Comprobar número de parámetros
if [[ $# -eq 0 ]]; then
    echo "Error: Se necesita un nombre de usuario como parámetro."
    read -p "Por favor, escribelo ahora: " usuario
elif [[ $# -eq 1 ]]; then
    usuario=$1
elif [[ $# -gt 1 ]]; then
    echo "Número de parámetros incorrectos"
    mostrar_ayuda
    exit 0
fi


# Comprobar si el usuario existe
if ! id "$usuario" &>/dev/null; then
    echo "Error: No sé quien es '$usuario'."
    exit 1
fi

# Información del usuario en /etc/passwd lo metemos en una variable
usuario_inf=$(grep "^$usuario:" /etc/passwd)

# Mostrar el menú y manejar las opciones
while true; do
    echo ""
    echo "Menú:"
    echo "1. Login."
    echo "2. Nombre."
    echo "3. Directorio."
    echo "4. Shell."
    echo "5. Procesos."
    echo "6. Salir."
    read -p "Seleccione una opción: " opcion
    echo ""

    case $opcion in
        1)
            echo "Login del usuario: $usuario"
            ;;
        2)
            nombre_completo=$(echo "$usuario_inf" | cut -d ':' -f 5 | cut -d ',' -f 1)
            echo "Nombre completo del usuario: $nombre_completo"
            ;;
        3)
            directorio=$(echo "$usuario_inf" | cut -d ':' -f 6)
            echo "Directorio del usuario: $directorio"
            ;;
        4)
            shell=$(echo "$usuario_inf" | cut -d ':' -f 7)
            echo "Shell del usuario: $shell"
            ;;
        5)
            # ps: comando para procesos
            ps -u "$usuario" -o pid,comm #--no-headers
            ;;
        6)
            echo "Saliendo del script..."
            exit 0
            ;;
        *)
            echo "Esa no es una opción válida. Por favor, elige una opción del 1 al 6 :P"
            ;;
    esac
done
