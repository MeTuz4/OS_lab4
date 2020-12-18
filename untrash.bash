#!/bin/bash

if ! [[ -e $HOME/.trash ]]
then
    echo "Корзина не обнаружена"
    exit 1
fi

if ! [[ -d $HOME/.trash ]]
then
    echo "Корзина не обнаружена"
    exit 2
fi

if ! [[ -e $HOME/.trash/.trash.log ]]
then
    echo ".trash.log не обнаружен"
    exit 4
fi

if [[ $# != 1 ]]
then
    exit 3
fi

fileName="$1"

if ! [[ $(grep $fileName "$HOME/.trash/.trash.log") == "" ]]
then
    echo "Файлов с таким именем нет"
    exit 5
fi

grep $fileName $HOME/.trash.log |
while read line
do
    filePath=$(echo $line | awk '{print $1}')
    fileInfo=$(echo $line | awk '{print $2}')
    echo "Вы хотите востановить файл по этому расположению: $filePath ?"
    read -p "Введите (yes), если этот ваш файл: " answer <&1
    case $answer in
	yes)
	    dir=$(echo ${filePath%"/$fileName"})
	    
	    if [ -e $dir ]
	    then
		if [ -d $dir ]
		then
		    read -p "$dir существует."
		    while [ -f $filePath ]
		    do
			if [ -f $filePath ]
			then
			read "Такой файл уже есть, требуется ввести другое название:" fileName <&1
			else
			echo "Название уникально, файл создаётся."
			ln "$HOME/.trash/.$fileInfo" "$filePath/$fileName"
			rm "$HOME/.trash/.$fileInfo"
			fi
		    done
		else
		    flag=1
		fi
	    else
		flag=1
	    fi
	    
	    if [ flag == 1 ]
	    then
		echo "Директория больше не существует, файл востановится в домашней директории."
		while [ -f $filePath ]
		do
		    if [ -f $filePath ]
		    then
		    read "Такой файл уже есть, требуется ввести другое название:" fileName <&1
		    else
		    echo "Название уникально, файл создаётся."
		    ln "$HOME/.trash/.$fileInfo" "$filePath/$fileName"
		    rm "$HOME/.trash/.$fileInfo"
		    fi
		done
	    fi
	;;
	*)
	    continue
	;;
    esac
done