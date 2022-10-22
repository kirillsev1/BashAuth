#!/bin/bash
photo_flag=True
if ! [[ -f "log.txt" ]]
then
    echo "Еще никто не регистрировался"
else
    for ((j=0;j < 3; j++))
    do
        echo "Попытка №$(($j + 1))"
        echo "Введите логин для авторизации"
        read name
        echo "Введите пароль"
        read -s passw
        echo $passw | md5sum > timefile.txt
        read passw < timefile.txt
        i=1
        flag=True
        indname=0
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
            done < log.txt
        
        ansflag=False
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
            done < log.txt
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
        fswebcam -r 640x480 --jpeg 85 -D 1 ./photo/`date +%d-%m-%y_%H-%M-%S`_$HOSTNAME.jpg
    fi
fi
