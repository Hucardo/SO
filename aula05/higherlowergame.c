/*Higher or lower game*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(void)
{
    int guess, number, count = 0;
    char answer;

    srand(time(NULL));
    number = rand() % 100 + 1;

    printf("I'm thinking of a number between 1 and 100.\n");
    printf("Can you guess what it is?\n");
    printf("%d\n", number);
    printf("Please type your first guess: ");
    scanf("%d", &guess);
    count++;
    while (guess != number)
    {
        if (guess > number)
        {
            printf("Sorry, %d is wrong. My number is less than that.\n", guess);
        }
        else
        {
            printf("Sorry, %d is wrong. My number is greater than that.\n", guess);
        }
        printf("Please try again: ");
        scanf("%d", &guess);
        count++;
    }

    printf("\nCongratulations! You got it in %d guesses!\n", count);

    return 0;
}