#!/bin/bash

function espaco() {
    local dir="$1"
    local space=0

    if [[ ! -d "$dir" ]]; then
        echo "Erro: Diretório inválido"
        return 1
    fi

    for i in "$dir"/*; do
        if [[ -f "$i" ]]; then
            space=$(du -h "$i" | awk '{print $1}' | grep -oE '[0-9.]+')
        elif [[ -d "$i" ]]; then
            espaco "$i"
        fi
        total_var=$(echo "$total_var + $space" | bc)
    done
}

# Usage example
total_var=0
espaco ~/SO/aula01
total1=$total_var
total_var=0
espaco ~/SO/aula02
total2=$total_var
total_var=0
espaco ~/SO
total3=$total_var

echo "Total Disk Usage for aula01: $total1"
echo "Total Disk Usage for aula02: $total2"
echo "Total Disk Usage for SO: $total3"
