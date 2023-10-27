#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char *argv[])
{
    if(argc != 4){
        printf("Tens de inserir 3 argumentos\n");
        return EXIT_FAILURE;
    }    

    double num1 = atoi(argv[1]);
    double num2 = atoi(argv[3]);
    char op = argv[2][0];

    switch (op)
    {
    case '+':
        printf("%.02f\n", num1 + num2);
        break;
    case '-':
        printf("%.02f\n", num1 - num2);
        break;
    case 'x':
        printf("%.02f\n", num1 * num2);
        break;
    case '/':
        printf("%.02f\n", num1 / num2);
        break;
    case 'p':
        printf("%.02f\n", pow(num1, num2));
        break;
    default:
        printf("Operador invalido\n");
        break;
    }
    return EXIT_SUCCESS;
}