#!/bin/bash
# This script checks the existence of a file
if [ $# -ne 1 ]; then
    echo "Tens de passar um string como argumento"
    exit 1
fi

echo "Checking..."
if [[ -f $1 ]] ; then
 echo "$1 existe."
else
 echo "$1 não existe"
fi
if [[ -d $1 ]] ; then
 echo "$1 existe e é um dir."
else
 echo "$1 não existe ou não é um dir"
fi
echo "As permissões do ficheiro são:"
ls -l $1




echo "...done." 
