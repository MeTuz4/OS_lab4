#!/bin/bash

if [[ $# != 1 ]]
then
    exit
fi

fileName="$1"

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
	    echo kek
	;;
    esac
done