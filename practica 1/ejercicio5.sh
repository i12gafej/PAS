#!/bin/bash


if [ $# -ne 2 ]
then
    echo "Argumentos insuficientes. USO: ./ejercicio5.sh <ruta> <numero de bytes>"
    exit 1
fi
if [ -d $1 ]
then 
    echo "la carpeta existe"
else 
    echo "$1 no es un directorio"
    exit 1
fi

for filen in $(ls $1)
do
    concreto="$(grep -o x $filen | wc -l)"
    if [ -n $concreto ]
    then 
        concreto=0
    else
        concreto=1
    fi
    peso="$(stat -c %s $1$filen)"
    if [ $peso -ge $2 ]
    then
        echo "$filen;$(stat -c %w $1$filen);$peso;$(stat -c %A $1$filen);$concreto"
    fi
done