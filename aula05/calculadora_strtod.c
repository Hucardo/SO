#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char *argv[])
{   
    char *point;
    if(argc != 4){
        printf("Tens de inserir 3 argumentos\n");
        return EXIT_FAILURE;
    }    

    double num1 = strtod(argv[1], &point);
    if(*point != '\0'){
        printf("O primeiro argumento nao e um numero\n");
        return EXIT_FAILURE;
    }
    double num2 = strtod(argv[3], &point);
    if(*point != '\0'){
        printf("O segundo argumento nao e um numero\n");
        return EXIT_FAILURE;
    }
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