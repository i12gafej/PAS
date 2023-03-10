#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Argumentos insuficientes. USO: ./ejercicio3.sh <ruta-origen> <ruta-final>"
    exit 1
fi

if [ -d $1 ]
then 
    echo "la carpeta existe"
else 
    echo "La carpeta no existe"
    mkdir $1
fi

mkdir -p $2

entrada=$1
entrada="${entrada%'/'}" #quita barra
fecha="$(date +%s)" #guarda fecha
r=$entrada"_"$USER"_"$fecha".tar.gz" #guarda nombre tar
tar -cvf $r $1/ #crea tar
mv $r $2/ #mueve tar a salida
echo "Creada la carpeta comprimida $2$r"

for filen in $(ls $2) 
do
    segundos="$(stat -c %Y $2/$filen)";
    res="$(($fecha-$segundos))"
    if [ $res -ge 200 ]
    then
        echo "borramos el archivo $2/$filen"
        rm -r $2/$filen
    fi
done


