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
echo "...done." 
