#!/bin/bash
infint=True
echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "rules" >> log.txt
while read line
do
    echo $line
done < rules.txt

while [[ $infint == True ]]
do 
    echo "Введите логин для регистрации"
    read name
    echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "Input" $name >> log.txt
    if [[ $name == *" "* ]]
    then
        echo "Запись содержит пробелы"
        continue
    fi
    i=1
    flag=True
    echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "check_name" >> log.txt
    if [[ -f "datebase.txt" ]]
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
        done < datebase.txt
    fi
    if [[ $flag == False ]]
    then
        echo "Такой логин уже существует" 
    else
        echo "Придумайте пароль"
        read -s passw
        echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "Input" $passw >> log.txt
        if [[ $passw == *" "* ]]
        then
            echo "Запись содержит пробелы"
            continue
        fi
        if [[ $passw == "" ]]
        then
            echo "Пароль не может быть пустым" 
        else

            echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "output" >> log.txt
            echo "Вы зарегистрированы"
            echo "$name" >> datebase.txt
            echo $passw | md5sum | awk '{print $1}' >> datebase.txt
            infint=False
        fi
    fi
done