#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Argumentos insuficientes. USO: ./ejercicio2.sh <ruta>"
    exit 1
fi

if [ -e $1 ]
then
    echo "Cambiando permisos de directorios..."

    chmod 750 $1
    chmod 750 $1/*
    find $1/* -maxdepth 0

    echo "Añadiendo permisos de ejeccion a scripts..."

    chmod u+x $1/*/*.sh
    ls -1 $1/*/*.sh

    echo "Añadiendo permisos las claves..."

    chmod 700 $1/*/*.key
    ls -1 $1/*/*.key
fi