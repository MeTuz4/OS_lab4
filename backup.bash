#!/bin/bash

flag=0
DATE=$(date +"%Y-%m-%d")
dateInSec=$(date -d "$DATE" +"%s")
lastBackup=$(ls "$HOME" | grep -e "^Backup-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$" | sort -n | tail -1)
date2=$(echo $lastBackup | cut -c "8-17")
date2InSec=$(date -d "date2" +"%s")
rangeDate=$(echo ($dateInSec-$date2InSec)/24/60/60 | bc)

if [[ $rangeDate -lt 7 ]]
then
    flag=1
fi

if [[ $lastBackup == "" ]]
then
    flag=0
fi

if [[ flag ]]
then
    mkdir "Backup-"$DATE
    echo "Сделан новый backup: Backup-$DATE" >> $HOME/backup-report
    for line in ($ls "$HOME/source")
    do
	cp "$HOME/source/$line" "$HOME/Backup-$DATE"
	echo "$line" >> $HOME/backup-report
    done
    echo "" >> $HOME/backup-report
else
    cd $HOME/$lastBackup
    echo "Список изменений:" >> temp
    for line in $(ls)
    do
	if ! [[ -f "$HOME/$lastBackup/$line" ]]
	then
	    cp "$HOME/source/$line" "HOME/$lastBackup"
	    echo "Добавлен $line" >> temp
	else
	    oldSize=$(wc -c "$HOME/$lastBackup/$line" | awk '{print $1}')
	    newSize=$(wc -c "$HOME/$lastBackup/$line" | awk '{print $1}')
	    if [[ "$newSize" -ne "$oldSize" ]]
	    then
		mv "$HOME/$lastBackup/$line" "$HOME/$lastBackup/$line.$date2"
		echo "Именён $line" >> temp
		cp "$HOME/source/$line" "$HOME/$lastBackup/$line"
	    fi
	fi
    done
    cat temp >> $HOME/$lastBackup
    rm temp
fi
