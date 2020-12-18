#!/bin/bash

if [[ $# != 1 ]]
then
    exit 1
fi

input="$1"
fileName=$(find . -type f -name "$input")

if ! [ -e $HOME/.trash ]
then
    mkdir "$HOME/.trash"
fi

if ! [ -d $HOME/.trash ]
then
    mkdir "HOME/.trash"
fi

if ! [ -e $HOME/.trash/.counter ]
then
    echo 0 > "$HOME/.trash/.counter"
fi

if ! [ -e $1 ]
then
    echo "Файл не существует"
    exit 1
fi

if ! [ -f $1 ]
then
    echo "Данный файл является каталогом"
fi

linkName=$(cat $HOME/.trash/.counter)
ln "$fileName" "$HOME/.trash/.$linkName"

filePath="$(pwd)/$input"
rm "$(pwd)/$input"

echo "$filePath $linkName" >> "$HOME/.trash.log"

let linkName=$linkName+1
echo $linkName > $HOME/.trash/.counter
