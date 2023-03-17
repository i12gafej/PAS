#!/bin/bash

cd
uso="/etc/group"

#cat $uso
echo "1) Grupos que contengan al menos 1 usuario ademas del usuario principal"
cat $uso | grep -o [[:alnum:]]*:[[:alnum:]]*:[1-9]*:[[:alnum:]]*[^$HOSTNAME][[:alnum:]]*

echo " 2) Grupos cuyo nombre empiece por u y acabe en s."
cat $uso | grep -E '^u[a-z]*s\:'

echo "2) Grupos cuyo nombre contenga dos letras iguales seguidas."
cat $uso | grep -E '^.*([a-z])\1[a-z].*:'

echo "3) Grupos que no contengan n i n g n usuario adicional"
cat $uso | grep -E '^.*:.*:.*:$'

echo "4) Grupos con GID menor que 100"
for linea in $(cat $uso)
do
    numero=$(echo $linea | grep -o '[[:alnum:]]*:[[:alnum:]]*:[[:alnum:]]*' | sed -E 's/^.*://')
    l=${#numero}
    if [ $l -lt 3 ]
    then 
        echo $linea
    fi
done
