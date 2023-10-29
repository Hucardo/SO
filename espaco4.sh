#!/bin/bash

IFS=$'\n'

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



while getopts "d:n:ras:l:" opt; do
    case $opt in
        d)
            if [[ ! $input_string =~ "^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [1-9]|[1-2][0-9]|3[0-1] [0-1][0-9]|2[0-3]:[0-5][0-9]$" ]]; then
                echo "-d requere uma data do tipo '$(date "+%b %d %H:%M")'"
                exit 1
            fi

            flag_d=$(date -d "$OPTARG" +%s) #Data especificada (No formato M d HH:MM)
            ;;
        n)
            flag_n="$OPTARG" #ficheiros com o padrão especificado
            if [[ "${flag_n:0:1}" == "-" ]]; then
                echo "-n requere uma string (pattern)"
                exit 1
            fi
            ;;
        r)
            flag_r=1 #Ordem crescente
            ;;
        a)
            flag_a=1 #Com ordenação por nome
            ;;
        s)
            flag_s="$OPTARG" #>=flag_s kbs
            if [[ ! $flag_s =~ ^[0-9]+$ ]]; then
                echo "-s requere um número."
                exit 1
            fi
            ;;
        l)
            flag_l="$OPTARG" #Com limite de linhas flag_l
            if [[ ! $flag_l =~ ^[0-9]+$ ]]; then
                echo "-l requere um número."
                exit 1
            fi
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            ;;
    esac
done

if [[ -z "$flag_d" ]] || [[ -z "$flag_n" ]] || [[ -z "$flag_s" ]] || [[ -z "$flag_l" ]]; then
    echo "Required options are missing or have no arguments."
    exit 1
fi

echo "SIZE NAME $(date +%Y%m%d) $@"

function espaco() {
    local temp_var=0
    local dir="$1"
    local space=0
    if [[ ! -d "$dir" ]]; then #se não for um diretório
        echo "Erro: Diretório inválido"
        return 1
    fi

    dirs=()
    # Use process substitution and while loop to read find output line by line
    while IFS= read -r -d '' directory; do
        dirs+=("$directory")
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d ! -name "*.*" -print0)

    files=()
    # Use process substitution and while loop to read find output line by line
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$dir" -maxdepth 1 -type f -name "$flag_n" ! -newermt "@$flag_d" -print0)

    #encontra os ficheiros em $dir com o nome a corresponder a $flag_n alterados não depois de $Flag_d
    for j in "${files[@]}"; do #itera sobre a dict de ficheiros encontrados
        space=$(du "$j" | awk '{print $1}' | grep -oE '[0-9.]+') #encontra o tamanho do ficheiro usando du
        if [[ $space -ge $flag_s ]] ; then #verifica se o tamanho do ficheiro encontra os requisitos de tamanho
            total_var=$(echo "$total_var + $space" | bc) #soma o espaço do ficheiro analisado ao total até agora
        fi
    done
    for k in "${dirs[@]}"; do
        temp_var=$total_var
        total_var=0
        espaco "$k"
        total_var=$(( $temp_var + $total_var ))
    done
    dict["$dir"]=$total_var
}

function ordenador(){
    for i in "${!dict[@]}"; do
        if [[ "${dict["$i"]}" == "" ]]; then
            dict["$i"]=NA
        fi
    done

    IFS=$'\n'
    if [[ $flag_r -eq 0 ]] && [[ $flag_a -eq 0 ]]; then
        for key in "${!dict[@]}"; do
            printf "%s %s\n" "${dict["$key"]}" "$key"
        done | sort -k1,1nr | while read -r line; do
            space=$(echo "$line" | awk '{print $1}')
            dir=$(echo "$line" | cut -d" " -f2-)
            printf "%s %s\n" "$space" "$dir"
        done #ordena a dict por ordem decrescente de tamanho e guarda os nomes dos diretórios ordenados
    fi

    if [[ $flag_r -eq 1 ]] && [[ $flag_a -eq 0 ]]; then
        for key in "${!dict[@]}"; do
            printf "%s %s\n" "${dict["$key"]}" "$key"
        done | sort -k1,1n | while read -r line; do
            space=$(echo "$line" | awk '{print $1}')
            dir=$(echo "$line" | cut -d" " -f2-)
            printf "%s %s\n" "$space" "$dir"
        done #ordena a dict por ordem crescente de tamanho e guarda os nomes dos diretórios ordenados
    fi

    if [[ $flag_a -eq 1 ]] && [[ $flag_r -eq 0 ]]; then
        for key in "${!dict[@]}"; do
            printf "%s %s\n" "${dict["$key"]}" "$key"
        done | sort -k2,2 | while read -r line; do
            space=$(echo "$line" | awk '{print $1}')
            dir=$(echo "$line" | cut -d" " -f2-)
            printf "%s %s\n" "$space" "$dir"
        done #ordena a dict por ordem alfabetica e guarda os nomes dos diretórios ordenados
    fi

    if [[ $flag_r -eq 1 ]] && [[ $flag_a -eq 1 ]]; then
        for key in "${!dict[@]}"; do
            printf "%s %s\n" "${dict["$key"]}" "$key"
        done | sort -k2,2r | while read -r line; do
            space=$(echo "$line" | awk '{print $1}')
            dir=$(echo "$line" | cut -d" " -f2-)
            printf "%s %s\n" "$space" "$dir"
        done #ordena a dict por ordem alfabetica reversa e guarda os nomes dos diretórios ordenados
    fi
    unset IFS
}

function printer() {
    ordenador
    #count=1
	#for i in "${ordered[@]}" ; do
	#	if [[ ! $count -gt $flag_l ]] || [[ $flag_l -eq 0 ]] ; then
    #        num=$i
    #        if [[ $num == -1 ]]; then
    #            num="NA"
    #        fi
    #       echo wot
    #    	echo "$num ${dict["$i"]}"
    #        count=$(( $count + 1 ))
    #    fi
	#done
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
        total_var=0
	    espaco "$l"
    fi
done
printer
unset IFS
