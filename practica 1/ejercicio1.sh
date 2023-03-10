#!/bin/bash

direc=$1
subirec=$2
men=$3
ma=$[$4-$men]

mkdir -p $direc

for (( c=0; c<$2; c++ ))
do
    x=$((($RANDOM%$ma)+$men))
    pal=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c $x)
    mkdir $1/$pal 
    
    for y in .txt .sh .key .html
    do
        x=$((($RANDOM%$ma)+$men))
        pal2=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c $x)
        touch $1/$pal/$pal2$y
    done
done
