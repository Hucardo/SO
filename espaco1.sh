#!/bin/bash
shopt -s extglob
function espaco() {
    local dir="$1"
    local space=0
    if [[ ! -d "$dir" ]]; then
        echo "Erro: Diretório inválido"
        return 1
    fi
    directories=($(find "$dir" -type d))
    for i in "${directories[@]}"; do
	files=($(find "$i" -maxdepth 1 -type f))
	for j in "${files[@]}"; do
	        if [[ ! -d "$j" ]]; then
	            space=$(du "$j" | awk '{print $1}' | grep -oE '[0-9.]+')
	        fi
	        total_var=$(echo "$total_var + $space" | bc)
	done
    done
}


#Testes
total_var=0
espaco aula01
total1=$total_var

echo "Total Disk Usage for AED: $total1"
