#!/bin/bash
photo_flag=True
if ! [[ -f "datebase.txt" ]]
then
    echo "Еще никто не регистрировался"
else
    for ((j=0;j < 3; j++))
    do
        echo "Попытка №$(($j + 1))"
        echo "Введите логин для авторизации(У вас 5 секунд)"
        read -t 5 name
        echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "Input:" $name >> log.txt
        if [[ $name == "" ]]
        then
            echo "Слишком медленно"
            continue
        fi
        echo "Введите пароль"
        read -s -t 5 passw
        echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "Input:" $passw >> log.txt
        if [[ $passw == "" ]]
        then
            echo "Слишком медленно"
            continue
        fi
        echo $passw | md5sum | awk '{print $1}' > timefile.txt
        echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "md5sum" >> log.txt
        read passw < timefile.txt
        i=1
        flag=True
        indname=0
        echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "check_name" >> log.txt
        while read line
        do
            if [[ $(($i % 2)) == 1 ]]
            then
                if [[ $name == $line ]]
                then
                    indname=$i
                    flag=False
                fi
            fi
            i=$(($i + 1))
        done < datebase.txt
        
        ansflag=False
        echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "check_password" >> log.txt
        if [[ $flag == False ]]
        then
            i=1
            while read line
            do
                if [[ $(($i % 2)) == 0 ]]
                then
                    if [[ $i == $(($indname + 1)) ]]
                    then
                        if [[ $passw  == $line ]]
                        then
                            ansflag=True
                        fi
                    fi
                fi
                i=$(($i + 1))
            done < datebase.txt
            if [[ $ansflag == True ]]
            then
                echo "$name, добро пажаловать в систему"
                photo_flag=False
                break
            else
                echo "Неверный пароль"
            fi
        else
            echo "Неверный логин"
        fi
    done
    rm timefile.txt
    if [[ $j == 3 ]]
    then
        if [[ ! -d photo ]]
        then
            mkdir photo
        fi
        echo $HOSTNAME:`date +%d-%m-%y_%H-%M-%S`: "try" $(($j + 1)): "take_photo" >> log.txt
        fswebcam -r 640x480 --jpeg 85 -D 1 ./photo/`date +%d-%m-%y_%H-%M-%S`_$HOSTNAME.jpg
    fi
fi
