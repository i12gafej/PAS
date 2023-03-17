#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Argumentos incorrectos. Uso: ./ejercicio3.sh <fichero>"
    exit 1
fi
let c=0
let linea=1
previa=""
p=$(cat $1 | grep -oi -E "[a-z]*" | sort | tr '[:upper:]' '[:lower:]' | head -1)
#cat $1 | grep -oi -E "[a-z]*" | sort | tr '[:upper:]' '[:lower:]'
for palabra in $(cat $1 | grep -oi -E "[a-z]*" | sort | tr '[:upper:]' '[:lower:]')
do
    if [[ $p == $palabra ]]
    then 
        c=$(($c+1))
        previa=$palabra
        
    else
        echo -e "$linea \t\t $c \t\t $previa"
        previa=$palabra
        c=1
        p=$palabra
        linea=$(($linea+1))        
    fi
done
echo -e "$linea \t\t $c \t\t $previa"
