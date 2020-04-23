#!/bin/bash

Error_1(){
    echo "La ruta especificada no existe o  no se tienen los permisos requeridos, $info"
    exit 1
}

info="para más información ejecute $0 -h"

cd $1 2> /dev/null || Error_1

declare -A apariciones
declare -a archivos

#Guardo en este array el solo el nombre de la compañía de cada archivo
archivos=$(ls | cut -f 1 -d "-")

#Array asociativo por nombre de compañía
#Incremento uno por cada aparición de un archivo de la compañía en el directorio
for arch in ${archivos[*]}
do
    (( apariciones[$arch]++ ))
done

#Recorro cada compañía y si tiene más de dos apariciones elimino las dos primeras/más antiguas
for i in ${!apariciones[*]}
do
    if test ${apariciones[$i]} -ge 2
    then 
        archivos=($(echo $(ls -1 | grep "$i") | tr " " "\n"))
        # echo ${#archivos[*]}
        # echo ${archivos[*]}
        for (( j=0; j<${#archivos[*]}-1; j++))
        do
            rm -f "${archivos[$j]}"
        done
    fi
done 
