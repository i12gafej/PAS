#!/bin/bash 

if [ $# -ne 3 ] 
then    
    echo "Argumentos erroneos. Uso: ./ejercicio2.sh <fichero_ips> <intentos> <tiempo de espera>"
    exit 1
else 
    if [ ! -f $1 ]
    then
        echo "El fichero no existe"
        exit 1
    fi
fi

for ip in $(cat $1)
do
    cosa=$(ping -c $2 $ip | tail -2 )
    media=$(echo $cosa | grep -o '= [0-9].*\/' | sed -E 's/= [0-9]+\.[0-9]+\///' | sed -E 's/\/[0-9]+\.[0-9]+\///')
    bien=$(echo $cosa | grep -o '...%' | sed -E 's/%//')
    if [[ $bien == "100" ]]
    then    
        echo "La ip $ip no respondio en $3 segundos"        
    else
        echo "$ip $media ms"
    fi
done


#echo $cosa | grep -o '= [0-9].*\/' | sed -E 's/= [0-9]+\.[0-9]+\///' | sed -E 's/\/[0-9]+\.[0-9]+\///'
