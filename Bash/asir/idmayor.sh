#!/bin/bash
echo "Pedro Egea Ortega 1ºX"


# Función para mostrar ayuda
function mostrar_ayuda {
    echo "Uso: idmayor.sh [usuario1] [usuario2]"
}

# Comprobar número de parámetros
if [ $# -eq 0 ]; then
    read -p "Introduce el primer usario: " usuario1
    read -p "Introduce el segundo usario: " usuario2
else
    usuario1=$1
    usuario2=$2
fi
if [ $# -gt 2 ]; then
    mostrar_ayuda
    exit 0
fi

if [ $# -eq 1 ]; then
    read -p "Introduce el segundo usario: " usuario2
fi


# Comprobar si el usuario existe
if ! id "$usuario1" &>/dev/null; then
    echo "Error: No sé quien es '$usuario1'."
    exit 1
fi

if ! id "$usuario2" &>/dev/null; then
    echo "Error: No sé quien es '$usuario2'."
    exit 1
fi

# Información del usuario en /etc/passwd lo metemos en una variable
usuario1_inf=$(grep "^$usuario1:" /etc/passwd | cut -d ":" -f 1)
usuario1_id=$(grep "^$usuario1:" /etc/passwd | cut -d ":" -f 3)

usuario2_inf=$(grep "^$usuario2:" /etc/passwd | cut -d ":" -f 1)
usuario2_id=$(grep "^$usuario2:" /etc/passwd | cut -d ":" -f 3)

if [ $usuario1_id -gt $usuario2_id ]; then
    echo "El usuario $usuario1_inf ($usuario1_id) tiene un ID mayor que el usuario $usuario2_inf ($usuario2_id)"
elif [ $usuario2_id -gt $usuario1_id ]; then
    echo "El usuario $usuario2_inf ($usuario2_id) tiene un ID mayor que el usuario $usuario1_inf ($usuario1_id)"
else
    echo "Has introducido el mismo usuario (?)"
fi