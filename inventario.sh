#!/bin/bash
clear
echo "Esto es el inventerio de AmongMeme"
echo "=================================="

echo "Qué quieres hacer?"
echo "------------------"

echo "1.-Mostrar Personeajes"
echo "2.-Mostrar inventario de un personaje"
echo "3.-Salir"

read INPUT

if [ "$INPUT" == "3" ] || [ "$INPUT" == "" ]; then
	echo "Pos hasta luego"
	exit 0
fi

if [ "$INPUT" == "1" ]; then
	echo "Personajes:"

	echo "select id_character,name from characters" | mysql -u consulta amongmeme
elif [ "$INPUT" == "2" ]; then
	echo "Inventario"
	echo "=========="
	echo "De que personaje quieres el inventario?"
	read ID_CHARACTER

	if [ "$ID_CHARACTER" == "" ]; then
		echo "Has de introducir algún valor"
		exit 1
	fi

	CHARACTER=`echo "select name from characters where id_character=$ID_CHARACTER" | mysql -u consulta amongmeme | tail -1`
	echo "Inventario de $CHARACTER con Id $ID_CHARACTER:"
	echo "select * from characters_items_summary where id_character=$ID_CHARACTER" | mysql -u consulta amongmeme | cut -d $'\t' -f 4
else
	echo "Opción Incorrecta"
fi
