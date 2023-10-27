#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Tens de passar um número como argumento"
    exit 1
fi

numero=$1

if [ $numero -gt 5 ] && [ $numero -lt 10 ]; then
    echo "Número maior do que 5 e menor do que 10"
else
    echo "Número fora do intervalo entre 5 e 10"
fi
