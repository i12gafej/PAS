#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Argumentos insuficientes. USO: ./ejercicio6.sh <usuario>"
    exit 1
fi

mkdir -p homes

let x=0
for filen in $(ls homes/)
do
    if [ $1 == $filen ]
    then 
        x=1
    fi
done
if [ $x -eq 1 ] 
then 
    echo "Ya existe el directorio $1"
else                           
    mkdir homes/$1
    cp skel/* homes/$1
    echo $1 >> users.txt
fi

