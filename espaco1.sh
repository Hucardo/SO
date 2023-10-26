#!/bin/bash

function espaco() {
    local dir="$1"
    local space=0

    if [[ ! -d "$dir" ]]; then
        echo "Erro: Diretório inválido"
        return 1
    fi

    for i in "$dir"/*; do
        if [[ ! -d "$i" ]]; then
            space=$(du "$i" | awk '{print $1}' | grep -oE '[0-9.]+')
        else
            espaco "$i"
	    total_var=$(( $total_var + 4 ))
        fi
        total_var=$(echo "$total_var + $space" | bc)
    done
}

# Usage example
total_var=0
espaco ../../AED
total1=$total_var
total_var=0
espaco ../../MPEI
total2=$total_var
total_var=0
espaco ../../SO
total3=$total_var

echo "Total Disk Usage for AED: $total1"
echo "Total Disk Usage for MPEI: $total2"
echo "Total Disk Usage for SO: $total3"
