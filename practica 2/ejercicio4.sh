#!/bin/bash

cd
l="/etc/passwd"

echo -e "1) Usuarios del grupo 46"
cat $l | grep -E ^[a-z]*:.*:.*:46:.*
echo -e "\n"

echo -e "2) Usuarios cuyo nombre empiece y acabe con la misma letra"
cat $l | grep -E '^([a-zA-Z])[a-z]*\1:'
echo -e "\n"

echo -e "3) Usuarios cuyo nombre no contenga la letra a/A"
cat $l | grep -E '^[b-z]*:'
echo -e "\n"

echo -e "4) Usuarios con UID de 4 digitos"
for p in $(cat $l)
do
	userid=$(echo $p | grep -Eo ^[a-z]*:[*a-zA-Z]:[0-9]* | sed -E 's/^[a-z]*:[*a-zA-Z]://')
	if [ ${#userid} -eq 4 ]
	then 

		echo $p
	fi
done
echo -e "\n"

echo -e "5) Usuarios con nombre entre 3 y 5 caracteres"
for p in $(cat $l)
do
	usuarios=$(echo $p | grep -Eo "^[a-zA-Z\-]*:" | sed -E 's/://')
	if [ ${#usuarios} -ge 3 ]
	then
		if [ ${#usuarios} -le 5 ]
		then
			echo $p
		fi
	fi
done
echo -e "\n"
