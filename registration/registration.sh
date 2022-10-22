#!/bin/bash
infint=True
while [[ $infint == True ]]
do 
    while read line
    do
        echo $line
    done < rules.txt
    echo "Введите логин для регистрации"
    read name
    i=1
    flag=True
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
    if [[ $flag == False ]]
    then
        echo "Такой логин уже существует" \n
    else
        echo "Придумайте пароль"
        read passw
        if [[ $passw == "" ]]
        then
            echo "Пароль не может быть пустым" \n
        else
            echo "Вы зарегистрированы"
            echo "$name" >> log.txt
            echo "$passw" >> log.txt
            infint=False
        fi
    fi
done