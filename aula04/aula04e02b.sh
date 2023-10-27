#!/bin/bash

function numeric_to_string()
{
 case "$1" in
 1)
 echo "Um"
 return 1
 ;;
 2)
 echo "Dois"
 return 2
 ;;
 3)
 echo "Três"
 return 3
 ;;
 *)
 echo "Outro número"
 return 0
 esac
}

numeric_to_string $1

#isto e suposto ser feito a parte e não estar no scrip!

echo "Retorno: $?"
