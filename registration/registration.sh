#!/bin/bash
infint=True
while read line
do
    echo $line
done < rules.txt

while [[ $infint == True ]]
do 
    echo "Введите логин для регистрации"
    read name
    if [[ $name == *" "* ]]
    then
        echo "Запись содержит пробелы"
        continue
    fi
    i=1
    flag=True
    if [[ -f "log.txt" ]]
    then
        while read line
        do 
            if [[ $(($i % 2)) == 1 ]]
            then
                if [[ $name == $line ]]
                then
                    flag=False
                fi
            fi
            i=$(($i + 1))
        done < log.txt
    fi
    if [[ $flag == False ]]
    then
        echo "Такой логин уже существует" 
    else
        echo "Придумайте пароль"
        read -s passw
        if [[ $passw == *" "* ]]
        then
            echo "Запись содержит пробелы"
            continue
        fi
        if [[ $passw == "" ]]
        then
            echo "Пароль не может быть пустым" 
        else
            echo "Вы зарегистрированы"
            echo "$name" >> log.txt
            echo $passw | md5sum >> log.txt
            infint=False
        fi
    fi
done