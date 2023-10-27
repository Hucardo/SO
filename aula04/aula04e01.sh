#!/bin/bash

# Função para imprimir uma mensagem
function imprime_msg()
{
  echo "A minha primeira função"
  return 0
}

# Função para mostrar a data, o nome do PC e o nome do utilizador
function mostrar_info()
{
  data=$(date)
  nome_pc=$(hostname)
  utilizador=$(whoami)
  echo "$data"
  echo "$nome_pc"
  echo "$utilizador"
}
imprime_msg

mostrar_info

