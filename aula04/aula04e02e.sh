#!/bin/bash

echo "O primeiro número:"
read x

echo "O segundo número:"
read y

comparacao(){
    if [ "$x" -eq "$y" ]; then
        return 1
    else
        if [ "$x" -gt "$y" ]; then
            return 2
        else
            return 3
        fi
    fi
}

comparacao

var=$?

case $var in
    "1")
    echo "The numbers are equal"
    ;;
    "2")
    echo "The greatest is x=$x."
    ;;
    "3")
    echo "The greatest is y=$y."
    ;;
esac
