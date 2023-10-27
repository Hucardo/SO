#!/bin/bash

# Verifique se o número de argumentos é igual a 2
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <number between 0 and 99> <string starting with 'sec'>"
  exit 1
fi

# Valide o primeiro argumento como um número entre 0 e 99
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
  echo "Error: First argument must be a number between 0 and 99."
  exit 1
fi

if (( "$1" < 0 || "$1" > 99 )); then
  echo "Error: First argument must be a number between 0 and 99."
  exit 1
fi

# Valide o segundo argumento para começar com 'sec'
if [[ "$2" != sec* ]]; then
  echo "Error: Second argument must start with 'sec'."
  exit 1
fi

echo "Arguments are valid: $1 and $2"
