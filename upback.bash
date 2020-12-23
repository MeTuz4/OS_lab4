#!/bin/bash

if [[ -d "$HOME/restore" ]]
then
    rmdir "/$HOME/restore"
fi
mkdir "$HOME/restore"
lastBackup=$(ls $HOME | grep -e "^Backup-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$" | sort -n | tail -1)
if [[ $lastBackup == "" ]]
then
    echo "Backup не существует"
    exit 1
fi
for line in $(ls "$HOME/lastBackup" | grep -ev ".[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$" )
do
    cp "$HOME/$lastBackup/$line" "$HOME/$restore/$line"
done