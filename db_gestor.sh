#!/bin/bash

clear

echo "Gestor de la base de datos Among Meme"
echo "====================================="

echo "¿Que quieres hacer?"
echo "-------------------"

echo "1. Mostrar Personajes"
echo "2. Mostrar Items"
echo "3. Crear personaje"
echo "4. Crear Item"
echo "5. Dar Item a un Personaje"
echo "6. Actualizar un personaje"
echo "7. Eliminar personaje"
echo "Q. Salir"

read INPUT

clear
if [ "$INPUT" == "q" ] || [ "$INPUT" == "Q" ] || [ "$INPUT" == "" ]; then
	echo "Pos hasta luego"
	exit 0
fi
if [ "$INPUT" == "1" ]; then
	echo "Personajes:"
	echo "==========="

	echo "select id_character, name from characters" | mysql -u gestor amongmeme
elif [ "$INPUT" == "2" ]; then 

	echo "Inventario"
	echo "=========="
	echo "¿De qué personaje quieres ver el inventario?"

	read CHAR_ID

	if [ "$CHAR_ID" == "" ]; then
		echo "Has de introducir algún valor"
		exit 1
	fi

	QUERY="select * from char_item where id_character=$CHAR_ID" 
	echo $QUERY | mysql -u consulta amongmeme | cut -d $'\t' -f 4
elif [ "$INPUT" == "3" ]; then
	echo "Creación de personaje:"
	echo "======================"
	echo -n "Nombre: "
	read NAME

	echo -n "Edad: "
	read AGE

	echo -n "Puntos de vida: "
	read HP

	echo -n "Género[(M)ale, (F)emale, (N)on binary), (O)thers]: "
	read GENDER

	echo -n "Estilo de combate [(M)elee, (R)anged]: "
	read STYLE

	echo -n "Maná: "
	read MANA

	echo -n "Clase[(WA)rrior, (RO)gue, (MA)ge, (PA)ladin]: "
	read CLASS

	echo -n "Raza[(HU)man, (UN)dead, (DE)mon, (CY)borg]: "
	read RACE

	echo -n "Puntos de experiencia: "
	read XP

	echo -n "Nivel: "
	read LEVEL

	echo -n "Altura: "
	read HEIGHT

	QUERY="INSERT INTO characters (name, age, hp, gender,"
	QUERY="$QUERY style, mana, class, race, xp, level, height)"	
	QUERY="$QUERY VALUES ('$NAME', $AGE, $HP, '$GENDER',"
	QUERY="$QUERY '$STYLE', $MANA, '$CLASS', '$RACE', $XP, $LEVEL, $HEIGHT)"

	echo $QUERY | mysql -u gestor amongmeme

#elif [ "$INPUT" == "4" ]; then

elif [ "$INPUT" == "5" ]; then
	echo "SELECT id_item, item FROM items" | mysql -u gestor amongmeme

	echo "Selecciona el ID del Item que quieres dar: "
	read ID_ITEM

	echo "SELECT id_character, name FROM characters" | mysql -u gestor amongmeme

	echo "Selecciona el ID del Personaje al que quieres dar el item: "
	read ID_CHARACTER

	QUERY="INSERT INTO characters_items (id_character, id_item)"
	QUERY="$QUERY VALUES ($ID_CHARACTER, $ID_ITEM)"
	echo $QUERY | mysql -u gestor amongmeme

elif [ "$INPUT" == "6" ]; then
	echo "¿Qué personaje quieres actualizar? Introduce el nombre (o parte)"
	read CHAR_NAME

	NUM_LETTERS=`echo -n "$CHAR_NAME" | wc -m`
	
	if [ $NUM_LETTERS -lt 4 ]; then
		echo "El nombre de personaje debe de tener 4 caracteres o más"
		exit 1
	fi
	
	QUERY="SELECT id_character,name FROM characters WHERE name LIKE '%$CHAR_NAME%'"
	CHAR=`echo $QUERY | mysql -u gestor amongmeme | tail -n 1`

	if [ "$CHAR" == "" ]; then
		echo "ERROR: Nombre no encontardo"
		exit 4
	fi

	ID_CHAR=`echo "$CHAR" | cut -f 1`
	CHAR_NAME=`echo "$CHAR" | cut -f 2`

	echo "Nombre completo: $CHAR_NAME"
	echo -n "Introduce el nuevo nombre: "
	read NAME

	if [ "$NAME" == "" ]; then
		echo "ERROR: Debes introducir un nombre"
		exit 2
	fi

	if [ `echo -n "$NAME" | wc -m` -lt 4 ]; then
		echo "ERROR: El nombre és más corto de cuatro caracteres"
		exit 3
	fi

	QUERY="UPDATE characters SET name='$NAME' WHERE id_character=$ID_CHAR"
	echo $QUERY | mysql -u gestor amongmeme

elif [ "$INPUT" == "7" ]; then
	echo "Introduce password de Admin"
	read -s PASS

	echo "Introduce el nombre (o parte) del personaje que quieres eliminar:"
	read CHAR_NAME
	
	NUM_LETTERS=`echo -n "$CHAR_NAME" | wc -m`
	
	if [ $NUM_LETTERS -lt 4 ]; then
		echo "El nombre de personaje debe de tener 4 caracteres o más"
		exit 1
	fi
	
	QUERY="SELECT id_character FROM characters WHERE name LIKE '%$CHAR_NAME%'"
	ID_CHAR=`echo $QUERY | mysql -u gestor amongmeme | tail -n 1`
	if [ "$ID_CHAR" == "" ];then 
		echo "No hay coincidecias"
		exit 2
	fi
	QUERY="DELETE FROM characters_items WHERE id_character=$ID_CHAR"
	#echo "$QUERY"
	echo $QUERY | mysql -u enti -p$PASS amongmeme

	QUERY="DELETE FROM characters WHERE id_character=$ID_CHAR"
	#echo "$QUERY"
	echo $QUERY | mysql -u enti -p$PASS amongmeme

else
	echo "Opción incorrecta"
fi
