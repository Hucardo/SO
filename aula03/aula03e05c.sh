#!/bin/bash

# Função para adicionar o prefixo "new_" aos arquivos
add_prefix() {
    for f in "$1"/*; do
        if [ -f "$f" ]; then
            new_name="$1/new_$(basename "$f")"
            mv "$f" "$new_name"
            echo "Renomeado: $f -> $new_name"
        fi
    done
}

# Função para remover o prefixo "new_" dos arquivos
remove_prefix() {
    for f in "$1"/*; do
        if [ -f "$f" ]; then
            new_name="${f##*/}"
            new_name="${new_name#new_}"
            mv "$f" "$1/$new_name"
            echo "Renomeado: $f -> $1/$new_name"
        fi
    done
}

# Verificar o número de argumentos
if [ $# -ne 2 ]; then
    echo "Uso: $0 <diretório> <-a|-r>"
    exit 1
fi

# Verificar se o primeiro argumento é um diretório válido
if [ ! -d "$1" ]; then
    echo "$1 não é um diretório válido."
    exit 1
fi

# Verificar a opção -a (adicionar prefixo) ou -r (remover prefixo)
if [ "$2" = "-a" ]; then
    add_prefix "$1"
elif [ "$2" = "-r" ]; then
    remove_prefix "$1"
else
    echo "Opção inválida. Use -a para adicionar prefixo ou -r para remover prefixo."
    exit 1
fi
