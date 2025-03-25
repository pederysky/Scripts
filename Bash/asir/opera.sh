#!/bin/bash
echo "Pedro Egea Ortega 1ºX"

# Función de uso para mostrar cómo se debe ejecutar el script
uso() {
    echo "Uso: $0 [-n1 primer_numero] [-n2 segundo_numero]"
    exit 1
}




# Inicializa las variables
num1=""
num2=""
operacion=""



# Procesa los argumentos si se proporcionan
while [[ $# -gt 0 ]] && [[ $# -le 4 ]]; do
    case $1 in
        -n1)
            n1=$2
            ;;
        -n2)
            n2=$2
            ;;
        sumar|restar|multiplicar)
            operacion=$1
            ;;
        salir)
            echo "Saliendo..."
            exit 1
            ;;
        *)
            uso
            ;;
    esac
done

# Si no se proporcionaron los números, solicitarlos al usuario
if [ -z "$num1" ]; then
    read -p "Introduce el primer número: " n1
fi

if [ -z "$num2" ]; then
    read -p "Introduce el segundo número: " n2
fi

# Si no se proporcionó la operación, solicitarla al usuario
if [ -z "$operacion" ]; then
    echo "Elige una operación:"
    echo "1. Sumar"
    echo "2. Restar"
    echo "3. Multiplicar"
    echo "4. Salir"
    read -p "Introduce 1, 2, o 3: " opcion

    case $opcion in
        1)
            operacion="sumar"
            ;;
        2)
            operacion="restar"
            ;;
        3)
            operacion="multiplicar"
            ;;
        *)
            echo "Opción no válida."
            exit 1
            ;;
    esac
fi

# Función para sumar dos números
sumar() {
    echo "Resultado: $((n1 + n2))"
}

# Función para restar dos números
restar() {
    echo "Resultado: $((n1 - n2))"
}

# Función para multiplicar dos números
multiplicar() {
    echo "Resultado: $((n1 * n2))"
}



# Selecciona la operación a realizar
case $operacion in
    sumar)
        sumar
        ;;
    restar)
        restar
        ;;
    multiplicar)
        multiplicar
        ;;

    *)
        echo "Operación no válida. Usa: {sumar|restar|multiplicar}"
        exit 1
        ;;
esac
