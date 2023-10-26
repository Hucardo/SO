#!/bin/bash
shopt -s extglob
function espaco() {
    local dir="$1"
    local space=0
    echo $1
    echo dirstart
    if [[ ! -d "$dir" ]]; then
        echo "Erro: Diretório inválido"
        return 1
    fi
    directories=($(find "$dir" -mindepth 1 -maxdepth 1 -type d))
    echo directories
    return 0
    for i in "${directories[@]}"; do
	echo good
	if [[ ! "$i" -ef "$dir/.[^.]*" ]] ; then
		echo good
		echo $i
	        if [[ ! -d "$i" ]]; then
	            space=$(du "$i" | awk '{print $1}' | grep -oE '[0-9.]+')
	        else
	            espaco "$i"
	        fi
	        total_var=$(echo "$total_var + $space" | bc)
	fi
    done
}

#Testes
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
