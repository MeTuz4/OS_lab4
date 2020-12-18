#!/bin/bash

flag=0
DATE=$(date +"%Y-%m-%d")
dateInSec=$(date -d "$DATE" +"%s")
lastBackup=$(ls "$HOME" | grep -e "^Backup-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$" | sort -n | tail -1)
date2=$(echo $lastBackup | cut -c "8-17")
date2InSec=$(date -d "date2" +"%s")
rangeDate=$(echo ($dateInSec-$date2InSec)/24/60/60 | bc)
if [[ $rangeDate -ge 7 ]]
then
    flag=0
fi

if [[ flag ]]
then
    mkdir "Backup-"$DATE
    echo "Сделан новый backup: Backup-$DATE" >> $HOME/backup-report
    for line in ($ls "$HOME/source")
    do
	cp -f "$HOME/source/$line" "$HOME/Backup-$DATE"
	echo "$line" >> $HOME/backup-report
    done
else
    cd $HOME/$lastBackup
fi
