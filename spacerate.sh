#!/bin/bash

declare -A dictantigo
declare -A dictnovo
declare -A dictfinal


flag_a="1,1n"
flag_r=0
input_novo=""
input_antigo=""

while getopts "ar" opt; do
    case $opt in
        a)
            flag_a="1,1000"
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

r="r"
if [[ $flag_a == "1,1n" && $flag_r == 1 ]]; then
    r=""
elif [[ $flag_a == "1,1000" && $flag_r == 0 ]]; then
    r=""
fi

if [[ $# < 2 ]] || [[ $# > 4 ]]; then
    echo "Usage: $0 [-a] [-r] <input_novo> <input_antigo>"
    exit 1
fi


for arg in "$@"; do
    if [ -f "$arg" ]; then
        if [ -z "$input_novo" ]; then
            input_novo="$arg"
        elif [ -z "$input_antigo" ]; then
            input_antigo="$arg"
            break  # We found both files, so we can exit the loop
        fi
    fi
done

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
for key in "${!dictfinal[@]}"; do
    printf "%s %s\n" "${dictfinal["$key"]}" "$key"
done | sort -k"$flag_a$r" | while read -r line; do
    space=$(echo "$line" | awk '{print $1}')
    dir=$(echo "$line" | cut -d" " -f2-)
    printf "%s %s\n" "$space" "$dir"
done #ordena a dict por ordem decrescente de tamanho e guarda os nomes dos diretórios ordenados
