#!/bin/bash
shopt -s extglob
function espaco() {
    local dir="$1"
    local space=0
    if [[ ! -d "$dir" ]]; then
        echo "Erro: Diretório inválido"
        return 1
    fi
    files=($(find "$dir" -type f))
    for j in "${files[@]}"; do
        if [[ ! -d "$j" ]]; then
            space=$(du "$j" | awk '{print $1}' | grep -oE '[0-9.]+')
	    echo $j
	    echo $space
        fi
        total_var=$(echo "$total_var + $space" | bc)
    done
}


#Testes
total_var=0
espaco aula01
total1=$total_var
total_var=0
espaco aula02
total2=$total_var
total_var=0
espaco aula03
total3=$total_var

echo "Total Disk Usage for aula01: $total1"
echo "Total Disk Usage for aula02: $total2"
echo "Total Disk Usage for aula03: $total3"
