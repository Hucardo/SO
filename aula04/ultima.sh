#!/bin/bash

# Verifica se o número correto de argumentos foi passado
if [ "$#" -ne 1 ]; then
  echo "Uso: $0 <arquivo_de_entrada>"
  exit 1
fi

input_file="$1"
output_file="sorted_$1"

# Verifica se o arquivo de entrada existe
if [ ! -f "$input_file" ]; then
  echo "O arquivo de entrada '$input_file' não existe."
  exit 1
fi

# Lê os números do arquivo de entrada
numbers=($(cat "$input_file"))

# Função para encontrar o índice do menor elemento em um array
find_min_index() {
  local arr=("$@")
  local min_index=0
  for ((i = 1; i < ${#arr[@]}; i++)); do
    if [ ${arr[i]} -lt ${arr[min_index]} ]; then
      min_index=$i
    fi
  done
  echo "$min_index"
}

# Ordena os números usando o algoritmo de seleção
sorted_numbers=()
while [ ${#numbers[@]} -gt 0 ]; do
  min_index=$(find_min_index "${numbers[@]}")
  sorted_numbers+=("${numbers[min_index]}")
  unset "numbers[$min_index]"
  numbers=("${numbers[@]}")
done

# Escreve a lista ordenada em um novo arquivo
echo "${sorted_numbers[@]}" >"$output_file"

echo "Números ordenados foram salvos em '$output_file'."
