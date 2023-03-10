#!/bin/bash 

if [ $# -ne 1 ]
then
    echo "Argumentos erroneos. Uso :./ejercicio1.sh <fichero_peliculas>"
fi
if [ ! -f $1 ]
then
    echo "Se esperaba un fichero del tipo peliculas.txt"
fi

echo "1) Lineas con la diracion de las peliculas:"
cat $1 | grep "[0-9]hr [0-9][0-9]min"

echo "2) Solo pais de las peliculas"
cat $1 | grep -e "\-..*\-" -o

seis="$(grep -o 2016 $1 | wc -l)"
siete="$(grep -o 2017 $1 | wc -l)"
echo "Hay $seis peliculas del 2016 y $siete del 2017"

echo "4) Palabras que contengan d, l o t , una vocal , y misma letra"
cat $1 | grep -oi -E "[a-z]*([dlt])[aeiou]\1[a-z]*" 

echo "5) Lineas que acaben con 3 puntos y no empiecen por espacios"
cat $1 | grep -oi -E "^[^ ].*\.\.\.$"

echo "6) Mostrar las vocales mayusculas o minusculas que tengan tildes entre comillas"
cat $1 | sed  -E 's/([áéíóúÁÉÍÓÚ])/"\1"/g'






