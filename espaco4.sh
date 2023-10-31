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
            flag_d=$(date -d "$OPTARG" +%s 2>/dev/null) #Data especificada (No formato M d HH:MM)
            if [[ -z $flag_d ]]; then
                echo "Formato de data inválido"
                exit 1
            fi
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


function espaco() {
    local temp_var=0
    local dir="$1"
    counting=$(( $counting + 1 ))
    echo "$counting: $dir"
    local space=0
    if [[ ! -d "$dir" ]]; then #se não for um diretório
        echo "Erro: Diretório inválido"
        return 1
    fi

    dirs=()
    # Use process substitution and while loop to read find output line by line
    while IFS= read -r -d '' directory; do
        dirs+=("$directory")
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d ! -name "*.*" -print0 2>/dev/null)

    files=()
    find "$dir" -maxdepth 1 -type f -name "$flag_n" ! -newermt "@$flag_d" -print0 2>/dev/null > discard.txt
    check=$?
    if [[ $check -eq 1 ]]; then
        dict["$dir"]=-1
        return 1
    fi
    # Use process substitution and while loop to read find output line by line
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$dir" -maxdepth 1 -type f -name "$flag_n" ! -newermt "@$flag_d" -print0 )


    #encontra os ficheiros em $dir com o nome a corresponder a $flag_n alterados não depois de $Flag_d
    for j in "${files[@]}"; do #itera sobre a dict de ficheiros encontrados
        space=$(du "$j" 2>/dev/null| awk '{print $1}' | grep -oE '[0-9.]+') #encontra o tamanho do ficheiro usando du
        if [[ $space -ge $flag_s ]] ; then #verifica se o tamanho do ficheiro encontra os requisitos de tamanho
            total_var=$(echo "$total_var + $space" | bc) #soma o espaço do ficheiro analisado ao total até agora
        fi
    done
    for k in "${dirs[@]}"; do
        temp_var=$total_var
        #echo $temp_var
        total_var=0
        espaco "$k"
        if [[ $total_var -ge 0 ]];then
            total_var=$(( $temp_var + $total_var ))
        else
            total_var=$temp_var
        fi
    done
    dict["$dir"]=$total_var
}

function printer(){
    counter=1

    if [[ $flag_r -eq 0 ]] && [[ $flag_a -eq 0 ]]; then
        for key in "${!dict[@]}"; do
            printf "%s %s\n" "${dict["$key"]}" "$key"
        done | sort -k1,1nr | while read -r line; do
            if [[ $counter -gt $flag_l ]] && [[ $flag_l -ne 0 ]]; then
                exit 0
            fi
            space=$(echo "$line" | awk '{print $1}')
            if [[ $space == -1 ]]; then
                space="NA"
            fi
            dir=$(echo "$line" | cut -d" " -f2-)
            printf "%s %s\n" "$space" "$dir"
            counter=$(( $counter + 1 ))
        done #ordena a dict por ordem decrescente de tamanho e guarda os nomes dos diretórios ordenados
    fi

    if [[ $flag_r -eq 1 ]] && [[ $flag_a -eq 0 ]]; then
        for key in "${!dict[@]}"; do
            printf "%s %s\n" "${dict["$key"]}" "$key"
        done | sort -k1,1n | while read -r line; do
            if [[ $counter -gt $flag_l ]] && [[ $flag_l -ne 0 ]]; then
                exit 0
            fi
            space=$(echo "$line" | awk '{print $1}')
            dir=$(echo "$line" | cut -d" " -f2-)
            printf "%s %s\n" "$space" "$dir"
            counter=$(( $counter + 1 ))
        done #ordena a dict por ordem crescente de tamanho e guarda os nomes dos diretórios ordenados
    fi

    if [[ $flag_a -eq 1 ]] && [[ $flag_r -eq 0 ]]; then
        for key in "${!dict[@]}"; do
            printf "%s %s\n" "${dict["$key"]}" "$key"
        done | sort -k2,1000 | while read -r line; do
            if [[ $counter -gt $flag_l ]] && [[ $flag_l -ne 0 ]]; then
                exit 0
            fi
            space=$(echo "$line" | awk '{print $1}')
            dir=$(echo "$line" | cut -d" " -f2-)
            printf "%s %s\n" "$space" "$dir"
            counter=$(( $counter + 1 ))
        done #ordena a dict por ordem alfabetica e guarda os nomes dos diretórios ordenados
    fi

    if [[ $flag_r -eq 1 ]] && [[ $flag_a -eq 1 ]]; then
        for key in "${!dict[@]}"; do
            printf "%s %s\n" "${dict["$key"]}" "$key"
        done | sort -k2,1000r | while read -r line; do
            if [[ $counter -gt $flag_l ]] && [[ $flag_l -ne 0 ]]; then
                exit 0
            fi
            space=$(echo "$line" | awk '{print $1}')
            dir=$(echo "$line" | cut -d" " -f2-)
            printf "%s %s\n" "$space" "$dir"
            counter=$(( $counter + 1 ))
        done #ordena a dict por ordem alfabetica reversa e guarda os nomes dos diretórios ordenados
    fi
}


#MAIN
declare -A dict
maindir=$(pwd)
counting=0

for l in "$@"; do
    if [[ -d "$l" ]]; then
        l=$(realpath --relative-to="$maindir" "$l")
        total_var=0
	    espaco "$l"
    fi
done

if [[ "${#dict[@]}" == 0 ]]; then
    echo "Nenhum diretório inserido."
    exit 1
fi

echo "SIZE NAME $(date +%Y%m%d) $@"
printer
unset IFS
