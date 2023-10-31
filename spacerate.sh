#!/bin/bash

declare -A dictantigo
declare -A dictnovo
declare -A dictfinal


flag_a=0
flag_r=0

while getopts "ar" opt; do
    case $opt in
        a)
            flag_a=1
            ;;
        r)
            flag_r=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

if [[ $# == 2 ]]; then
    input_antigo=$2
    input_novo=$1
fi

if [[ $# == 3 ]]; then
    input_antigo=$3
    input_novo=$2
fi

if [[ $# == 4 ]]; then
    input_antigo=$4
    input_novo=$3
fi

if [ ! -f $input_antigo ]; then
    echo "File $input_antigo nao existe."
    exit 1
fi

if [ ! -f $input_novo ]; then
    echo "File $input_novo nao existe."
    exit 1
fi

if [ ! -r $input_antigo ]; then
    echo "File $input_antigo nao tem permissao de leitura."
    exit 1
fi

if [ ! -r $input_novo ]; then
    echo "File $input_novo nao tem permissao de leitura."
    exit 1
fi

first_line=true

while IFS= read -r line
do
  if [ "$first_line" = true ]; then
    first_line=false
    continue  
  fi

  size=$(echo "$line" | cut -d\  -f1)
  name=$(echo "$line" | cut -d\  -f2-)

  dictantigo["$name"]=$size

done < "$input_antigo"

first_line=true

while IFS= read -r line
do
  if [ "$first_line" = true ]; then
    first_line=false
    continue  
  fi

  size=$(echo "$line" | cut -d\  -f1)
  name=$(echo "$line" | cut -d\  -f2-)
  echo $name

  dictnovo["$name"]=$size

done < "$input_novo"

for key in "${!dictnovo[@]}"; do
    
    if [[ ${dictantigo["$key"]} ]]; then
        dictfinal["$key"]=$(( ${dictnovo["$key"]} - ${dictantigo["$key"]} ))
    
    else
        dictfinal["$key NEW"]=${dictnovo["$key"]}
    fi
done

for key in "${!dictantigo[@]}"; do
    if [[ ! ${dictnovo["$key"]} ]]; then
        dictfinal["$key REMOVED"]=$(( 0 - ${dictantigo["$key"]}))
    fi
done

echo "SIZE NAME"
if [[ $flag_r -eq 0 ]] && [[ $flag_a -eq 0 ]]; then
    for key in "${!dictfinal[@]}"; do
        printf "%s %s\n" "${dictfinal["$key"]}" "$key"
    done | sort -k1,1nr | while read -r line; do
        space=$(echo "$line" | awk '{print $1}')
        dir=$(echo "$line" | cut -d" " -f2-)
        printf "%s %s\n" "$space" "$dir"
    done #ordena a dict por ordem decrescente de tamanho e guarda os nomes dos diretórios ordenados
fi

if [[ $flag_r -eq 1 ]] && [[ $flag_a -eq 0 ]]; then
    for key in "${!dictfinal[@]}"; do
        printf "%s %s\n" "${dictfinal["$key"]}" "$key"
    done | sort -k1,1n | while read -r line; do
        space=$(echo "$line" | awk '{print $1}')
        dir=$(echo "$line" | cut -d" " -f2-)
        printf "%s %s\n" "$space" "$dir"
    done #ordena a dict por ordem crescente de tamanho e guarda os nomes dos diretórios ordenados
fi

if [[ $flag_a -eq 1 ]] && [[ $flag_r -eq 0 ]]; then
    for key in "${!dictfinal[@]}"; do
        printf "%s %s\n" "${dictfinal["$key"]}" "$key"
    done | sort -k2,2 | while read -r line; do
        space=$(echo "$line" | awk '{print $1}')
        dir=$(echo "$line" | cut -d" " -f2-)
        printf "%s %s\n" "$space" "$dir"
    done #ordena a dict por ordem alfabetica e guarda os nomes dos diretórios ordenados
fi

if [[ $flag_r -eq 1 ]] && [[ $flag_a -eq 1 ]]; then
    for key in "${!dictfinal[@]}"; do
        printf "%s %s\n" "${dictfinal["$key"]}" "$key"
    done | sort -k2,2r | while read -r line; do
        space=$(echo "$line" | awk '{print $1}')
        dir=$(echo "$line" | cut -d" " -f2-)
        printf "%s %s\n" "$space" "$dir"
    done #ordena a dict por ordem alfabetica e guarda os nomes dos diretórios ordenados
fi