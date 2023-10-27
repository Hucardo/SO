#!/bin/bash
# select structure to create menus

# Redefinindo a variável PS3 para alterar a mensagem ao usuário
PS3="Escolha uma opção (ou 'q' para sair): "

select arg in "$@"; do
    if [ -n "$arg" ]; then
        echo "Você escolheu $arg ($REPLY)."
    elif [ "$REPLY" = "q" ]; then
        echo "Saindo."
        break
    else
        echo "Opção inválida."
    fi
done
