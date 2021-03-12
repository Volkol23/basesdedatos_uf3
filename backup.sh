#!/bin/bash

if [ "$1" == "" ]; then
	echo -n "Indica el nombre del archivo: "
	echo -e "\t$0 NOMBRE_ARCHIVO"
	exit 1
fi

mysqldump -u backups amongmeme > /tmp/$1

tar czfi $1.tar.gz --absolute-names /tmp/$1

rm /tmp/$1
exit 0
