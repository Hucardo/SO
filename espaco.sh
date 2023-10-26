#!/bin/bash

function espaco() {

local -n total="$2"

#verificacao do numero de argumentos e se o primeiro argumento e um diretorio
if [[ "$#" -ne 2 ]] & [[ ! -d "$1" ]] ; then
	echo "Erro: argumentos incorretos"
	return 0
fi

#iterar o diretorio e determinar o espaco ocupado por todos os ficheiros
for i in "$1"/* ; do
	if [[ -f "$i" ]] ; then
		space=$(du -h "$i" | awk '{print $1}' | grep -oE '[0-9.]+')
	elif [[ -d "$i" ]] ; then
		espaco "$i" "$total"
	fi
	$2=$((echo "$total + $space" | bc))
done

echo $1
echo $2

}

total1=0
total2=0
total3=0

espaco ~/SO/aula01 $total1
espaco "~/SO/aula02" $total2
espaco "~/SO" $total3
espaco "~/SO/aula02/aula02e01.sh"
