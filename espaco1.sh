#!/bin/bash
shopt -s extglob
function espaco() {
    local dir="$1"
    local space=0
    echo dirstart
    if [[ ! -d "$dir" ]]; then
        echo "Erro: Diretório inválido"
        return 1
    fi
    directories=($(find "$dir" -type d))
    for i in "${directories[@]}"; do
	echo $i
	files=("$i"/*)
	echo "numero de ficheiros: ${#files[@]}"
	if [[ ${#files[@]} -eq 1 ]] ; then
		echo "vazio"
	else
		for j in "${files[@]}"; do
			echo $j
		        if [[ ! -d "$j" ]]; then
		            space=$(du "$j" | awk '{print $1}' | grep -oE '[0-9.]+')
			    echo $space
		        fi
		        total_var=$(echo "$total_var + $space" | bc)
		done
	fi
    done
}


#Testes a
total_var=0
espaco aula01
total1=$total_var
total_var=0
espaco aula02
total2=$total_var
total_var=0
espaco aula03
total3=$total_var

echo "Total Disk Usage for AED: $total1"
echo "Total Disk Usage for MPEI: $total2"
echo "Total Disk Usage for SO: $total3"
