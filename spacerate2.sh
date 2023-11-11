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

#r="r"
#if [[ $flag_a -eq "1,1n" && $flag_r -eq 1 ]] || [[ $flag_a -eq "2,1000" && $flag_r -eq 0 ]]; then
#    r=""
#fi
#isto ta a bugar o codigo nao sei porque

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

while IFS= read -r line; do
    if [ "$first_line" = true ]; then
        first_line=false
        continue  
    fi

    size=$(echo "$line" | cut -d' ' -f1)
    if [[ $size == "NA" ]]; then
        size=0
    fi
    name=$(echo "$line" | cut -d' ' -f2-)

    dictantigo["$name"]=$size
done < "$input_antigo"

first_line=true

while IFS= read -r line; do
    if [ "$first_line" = true ]; then
        first_line=false
        continue  
    fi

    size=$(echo "$line" | cut -d' ' -f1)
    if [[ $size == "NA" ]]; then
        size=0
    fi
    name=$(echo "$line" | cut -d' ' -f2-)

    dictnovo["$name"]=$size
done < "$input_novo"

for key in "${!dictnovo[@]}"; do
    if [[ ${dictantigo["$key"]} ]]; then
        if [[ ${dictnovo["$key"]} -eq "NA" || ${dictantigo["$key"]} -eq "NA" ]]; then
            dictfinal["$key"]="NA"
        else
            dictfinal["$key"]=$(( ${dictnovo["$key"]} - ${dictantigo["$key"]} ))
        fi
    else
        if [[ ${dictnovo["$key"]} -eq "NA" ]]; then
            dictfinal["$key NEW"]="NA"
        else
            dictfinal["$key NEW"]=${dictnovo["$key"]}
        fi
    fi
done

for key in "${!dictantigo[@]}"; do
    if [[ ! ${dictnovo["$key"]} ]]; then
        if [[ ${dictantigo["$key"]} -eq "NA" ]]; then
            dictfinal["$key REMOVED"]="NA"
        else
            dictfinal["$key REMOVED"]=$((- ${dictantigo["$key"]}))
        fi
    fi
done

echo "SIZE NAME"
for key in "${!dictfinal[@]}"; do
    if [[ ${dictfinal["$key"]} -eq "NA" ]]; then
        printf "NA %s\n" "${key}"
    else
        printf "%s %s\n" "${dictfinal["$key"]}" "$key"
    fi
done | sort -k"$flag_a$r"

# Check if there are elements in dictfinal with "NA" values
if [[ "${dictfinal[*]}" =~ "NA" ]]; then
    echo "NA"
fi
