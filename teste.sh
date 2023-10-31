#!/bin/bash

input_novo=""
input_antigo=""

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

# Check if both files were found
if [ -z "$input_novo" ]; then
    echo "Error: No valid input_novo file found."
fi

if [ -z "$input_antigo" ]; then
    echo "Error: No valid input_antigo file found."
fi

echo "input_novo: $input_novo"
echo "input_antigo: $input_antigo"
