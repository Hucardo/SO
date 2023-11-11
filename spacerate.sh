#!/bin/bash

declare -A dictantigo
declare -A dictnovo
declare -A dictfinal


flag_a="1,1n"
flag_r=0
input_novo=""
input_antigo=""

while getopts "ar" opt 2>/dev/null; do
    case $opt in
        a)
            flag_a="2,1000"
            ;;
        r)
            flag_r=1
            ;;
        \?)
            echo "Invalid option!" >&2
            exit 1
            ;;
    esac
done

r="r"
if [[ $flag_a == "1,1n" && $flag_r == 1 ]] || [[ $flag_a == "2,1000" && $flag_r == 0 ]]; then 
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

  size=$(echo "$line" | cut -d\  -f1) #separa o tamanho do nome do diretório
  name=$(echo "$line" | cut -d\  -f2-)

  dictantigo["$name"]=$size #guarda o tamanho e o nome do diretório numa dict

done < "$input_antigo"

first_line=true

while IFS= read -r line
do
  if [ "$first_line" = true ]; then
    first_line=false
    continue  
  fi

  size=$(echo "$line" | cut -d\  -f1) #separa o tamanho do nome do diretório
  name=$(echo "$line" | cut -d\  -f2-)

  dictnovo["$name"]=$size #guarda o tamanho e o nome do diretório numa dict

done < "$input_novo"

for key in "${!dictnovo[@]}"; do #percorre a dict do diretório novo
    
    if [[ ${dictantigo["$key"]} ]]; then #se o diretório já existia no diretório antigo
        dictfinal["$key"]=$(( ${dictnovo["$key"]} - ${dictantigo["$key"]} )) #guarda a diferença de tamanho entre o diretório antigo e o novo
    
    else #se o diretório é novo
        dictfinal["$key NEW"]=${dictnovo["$key"]} #guarda o tamanho do diretório novo
    fi
done

for key in "${!dictantigo[@]}"; do #percorre a dict do diretório antigo
    if [[ ! ${dictnovo["$key"]} ]]; then #se o diretório foi removido
        dictfinal["$key REMOVED"]="-${dictantigo["$key"]}" #guarda o simétrico do tamanho do diretório antigo
    fi
done

echo "SIZE NAME"
for key in "${!dictfinal[@]}"; do #percorre a dict final
    printf "%s %s\n" "${dictfinal["$key"]}" "$key" #imprime o tamanho e o nome do diretório
done | sort -k"$flag_a$r" | while read -r line; do #
    space=$(echo "$line" | awk '{print $1}') #
    dir=$(echo "$line" | cut -d" " -f2-) #
    printf "%s %s\n" "$space" "$dir" #
done #ordena a dict por ordem decrescente de tamanho e guarda os nomes dos diretórios ordenados