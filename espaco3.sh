#!/bin/bash


flag_d=$(date +%s)
flag_n="*"
flag_s=0
flag_r=0
flag_a=0
flag_l=0



while getopts ":d:n:ra:s:l:" opt; do
    case $opt in
        d)
            flag_d=$(date -d "$OPTARG" +%s)
            ;;
        n)
            flag_n="$OPTARG"
            ;;
        r)
            flag_a=1
            ;;
        a)
            flag_r=1
            ;;
        s)
            flag_s="$OPTARG"
            ;;
        l)
            flag_l="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            ;;
    esac
done
echo "SIZE NAME $(date +%Y%m%d) $@"

function espaco() {
    local dir="$1"
    local space=0
    if [[ ! -d "$dir" ]]; then
        echo "Erro: Diretório inválido"
        return 1
    fi
    files=($(find "$dir" -type f -name "$flag_n" -size +"$flag_s"c ! -newermt "@$flag_d"))
    for j in "${files[@]}"; do
        if [[ ! -d "$j" ]]; then
            space=$(du "$j" | awk '{print $1}' | grep -oE '[0-9.]+')
        fi
        total_var=$(echo "$total_var + $space" | bc)
    done
}

function subespaco(){
	dirs=($(find "$l" -type d))
	for i in "${dirs[@]}"; do
		total_var=0
		espaco $i
		lista[$i]=$total_var
	done
	#ORDENAR LISTA AQUI USANDO AS FLAGS
	#
	#
	#
	#
	#
	#
	#ORDENAR LISTA AQUI USANDO AS FLAGS
}

function print() {
    count=1
	for i in "${!lista[@]}" ; do
		if [[ ! $count -gt $flag_l ]] || [[ $flag_l -eq 0 ]] ; then
        	echo "${lista[$i]} $i"
            count=$(( $count + 1 ))
        fi
	done
}

declare -A lista
#Testes
for l in "$@"; do
    if [[ -d "$l" ]]; then
	    subespaco
    fi
done
print
