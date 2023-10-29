#!/bin/bash

if (( $# == 0 )); then
    echo "Erro: Nenhum argumento especificado"
    exit 1
fi

#valores por predefinição das flags
flag_d=$(date +%s) #HOJE
flag_n="*" #TODOS OS FICHEIROS
flag_s=0 #>=0 kbs
flag_r=0 #Ordem decrescente
flag_a=0 #Sem ordenação por nome
flag_l=0 #Sem limite de linhas



while getopts ":d:n:ra:s:l:" opt; do
    case $opt in
        d)
            flag_d=$(date -d "$OPTARG" +%s) #Data especificada (No formato M d HH:MM)
            ;;
        n)
            flag_n="$OPTARG" #ficheiros com o padrão especificado
            ;;
        r)
            flag_r=1 #Ordem crescente
            ;;
        a)
            flag_a=1 #Com ordenação por nome
            ;;
        s)
            flag_s="$OPTARG" #>=flag_s kbs
            ;;
        l)
            flag_l="$OPTARG" #Com limite de linhas flag_l
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
    if [[ ! -d "$dir" ]]; then #se não for um diretório
        echo "Erro: Diretório inválido"
        return 1
    fi
    files=($(find "$dir" -type f -name "$flag_n" ! -newermt "@$flag_d")) #encontra os ficheiros em $dir com o nome a corresponder a $flag_n alterados não depois de $Flag_d
    for j in "${files[@]}"; do #itera sobre a lista de ficheiros encontrados
        if [[ ! -d "$j" ]]; then #podemos remover
            space=$(du "$j" | awk '{print $1}' | grep -oE '[0-9.]+') #encontra o tamanho do ficheiro usando du
        fi
        if [[ $space -ge $flag_s ]] ; then #verifica se o tamanho do ficheiro encontra os requisitos de tamanho
            total_var=$(echo "$total_var + $space" | bc) #soma o espaço do ficheiro analisado ao total até agora
        fi
    done
}

function subespaco(){
	dirs=($(find "$l" -type d))
	for i in "${dirs[@]}"; do
		echo $i
        total_var=0
		espaco $i
		dict[$i]=$total_var
	done
}

function ordenador(){
    #Completar para nao calcular arreis desnecessariamente
    #basicamente mete aqui um if com as flags
    #podes mudar o nome dos arrais todos para o mesmo nome porque so 1 vai ser calculado
    #
    #
    #
    #
    ordered=($(for i in "${!dict[@]}"; do
        done | sort -k2,2nr | cut -d' ' -f1))

    reversed=($(for i in "${!dict[@]}"; do
        done | sort -k2,2n | cut -d' ' -f1))

    alphabetic=($(for i in "${!dict[@]}"; do
        done | sort))

    reversed_alphabetic=($(for i in "${!dict[@]}"; do
        done | sort -r))
}

function printer() {
    #Alterar para imprimir as cenas certas
    #aqui nao e preciso mudar muito se meteres os arrays do ordenador todos com o mesmo nome
    #
    #
    count=1
	for i in "${!dict[@]}" ; do
		if [[ ! $count -gt $flag_l ]] || [[ $flag_l -eq 0 ]] ; then
        	echo "${dict[$i]} $i"
            count=$(( $count + 1 ))
        fi
	done

    for i in "${ordered[@]}" ; do
        if [[ ! $count -gt $flag_l ]] || [[ $flag_l -eq 0 ]] ; then
        	echo "${dict[$i]} $i"
            count=$(( $count + 1 ))
        fi
    done
}
#apagar os arrays desnecessarios
#
#
#

declare -A dict
declare -a ordered
declare -a reversed
declare -a alphabetic
declare -a reversed_alphabetic
#Testes
for l in "$@"; do
    if [[ -d "$l" ]]; then
	    subespaco
    fi
done
printer
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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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