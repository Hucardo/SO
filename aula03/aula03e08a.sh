#!/bin/bash
# select structure to create menus

# Redefinindo a variável PS3 para alterar a mensagem ao usuário
PS3="Escolha uma opção: "

select arg in "$@"; do
    if [ -n "$arg" ]; then
        echo "Você escolheu $arg ($REPLY)."
    else
        echo "Opção inválida."
        break
    fi
done
