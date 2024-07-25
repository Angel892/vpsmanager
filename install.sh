#!/bin/bash

# Definir la variable para el alias
ALIAS_NAME="adm"
ALIAS_COMMAND="sudo /etc/vpsmanager/adm.sh"
ALIAS_DEFINITION="alias $ALIAS_NAME='$ALIAS_COMMAND'"

DIRECTORIO_PRINCIPAL="/etc/vpsmanager"

validarDirectorio() {
    directorio=$1
    # Verificar si el directorio ya existe
    if [ ! -d "$directorio" ]; then
        # Crear el directorio de destino, junto con los padres necesarios
        sudo mkdir -p "$directorio"
        if [ $? -ne 0 ]; then
            echo "Error: No se pudo crear el directorio $directorio."
            exit 1
        fi
        echo "Directorio $directorio creado."
    else
        # Eliminar el directorio
        sudo rm -r "$directorio"
        if [ $? -ne 0 ]; then
            echo "Error: No se pudo eliminar el directorio $directorio."
            exit 1
        fi
        echo "Directorio $directorio existente, Eliminándolo."

        # Crear el directorio de destino, junto con los padres necesarios
        sudo mkdir -p "$directorio"
        if [ $? -ne 0 ]; then
            echo "Error: No se pudo crear el directorio $directorio."
            exit 1
        fi
        echo "Directorio $directorio creado."
    fi
}

actualizarVPS() {
    # Actualizar la lista de paquetes y actualizar el sistema
    echo "Actualizando la lista de paquetes..."
    sudo apt-get update
    if [ $? -ne 0 ]; then
        echo "Error: Falló la actualización de la lista de paquetes."
        exit 1
    fi

    echo "Actualizando los paquetes instalados..."
    sudo apt-get upgrade -y
    if [ $? -ne 0 ]; then
        echo "Error: Falló la actualización de los paquetes instalados."
        exit 1
    fi
}

actualizarVPS;

validarDirectorio "$DIRECTORIO_PRINCIPAL"

#Verificar si git esta instalado si no instalarlo
if ! command -v git &>/dev/null; then
    echo "Git no está instalado. Instalando git..."
    sudo apt-get install -y git
    if [ $? -ne 0 ]; then
        echo "Error: No se pudo instalar git."
        exit 1
    fi
fi

# Clonar el repositorio en un directorio temporal
git clone https://github.com/Angel892/vpsmanager.git $DIRECTORIO_PRINCIPAL
if [ $? -ne 0 ]; then
    echo "Error: La clonación del repositorio falló."
    exit 1
fi

# Dar permisos de ejecución al script principal y a los scripts de funciones de manera recursiva
sudo find /etc/vpsmanager/ -type f -name "*.sh" -exec chmod +x {} \;
if [ $? -ne 0 ]; then
    echo "Error: No se pudieron asignar los permisos de ejecución."
    exit 1
fi

# Añadir alias al archivo de configuración del shell
if ! grep -q "$ALIAS_DEFINITION" ~/.bashrc; then
    echo "$ALIAS_DEFINITION" >>~/.bashrc
    if [ $? -ne 0 ]; then
        echo "Error: No se pudo añadir el alias a ~/.bashrc."
        exit 1
    fi
    echo "Alias '$ALIAS_NAME' añadido a ~/.bashrc. Aplicando cambios..."
    source ~/.bashrc
    if [ $? -ne 0 ]; then
        echo "Error: No se pudo aplicar los cambios del alias."
        exit 1
    fi
else
    echo "El alias '$ALIAS_NAME' ya existe en ~/.bashrc."
fi

# Ejecutar el script principal desde su nueva ubicación
$ALIAS_COMMAND
if [ $? -ne 0 ]; then
    echo "Error: Falló la ejecución del script principal."
    exit 1
fi
