#!/bin/bash

# Verificar o número de argumentos
if [ $# -ne 1 ]; then
    echo "Uso: $0 <diretório>"
    exit 1
fi

# Verificar se o argumento é um diretório
if [ ! -d "$1" ]; then
    echo "$1 não é um diretório válido."
    exit 1
fi

# Loop para mostrar as propriedades dos arquivos no diretório
for f in "$1"/*; do
    file "$f"
done
