#!/bin/bash 

if [ $# -ne 2 ]
then
    echo "Argumentos insuficientes. USO: ./ejercicio4.sh <ruta> <extensión>"
    exit 1
fi

if [ -d $1 ]
then 
    echo "la carpeta existe"
else 
    echo "$1 no es un directorio"
    exit 1
fi
respuesta=a
read -s -t5 -n1 -p "Introduzca el caracter" respuesta
if [ -z $respuesta ]
then 
    echo "Se utiliza la letra por defecto a\n"
fi
echo -e
echo "Ficheros:"
let cee=0;
for filen in $(ls $1*.$2)
do
    cee=$(($cee+1))
    caracteres="$(wc -c $filen | cut -d " " -f 1)"
    concreto="$(grep -o $respuesta $filen | wc -l)"
    filen="$(echo $filen | cut -d "/" -f 2)"
    echo -e "$cee \t\t $filen \t\t $caracteres \t\t $concreto"  
done
#wc -c $*.$2 | cut -d " " -f 1
#grep -o 'caracter' nombre_del_archivo | wc -l