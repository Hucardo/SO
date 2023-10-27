#!/bin/bash
# Calculate the sum and average of a series of numbers.

SCORE="0"
SUM="0"
COUNT="0"

while true; do
    echo -n "Enter your score [0-10] ('q' to quit, 'r' to reset): "
    read SCORE

    if [[ "$SCORE" == "q" ]]; then
        echo "Sum: $SUM."
        if [ "$COUNT" -eq 0 ]; then
            echo "No scores entered. Average: N/A."
        else
            AVERAGE=$(bc -l <<< "scale=2; $SUM / $COUNT")
            echo "Average: $AVERAGE."
        fi
        break
    elif [[ "$SCORE" == "r" ]]; then
        SUM="0"
        COUNT="0"
    elif (("$SCORE" < "0")) || (("$SCORE" > "10")); then
        echo "Invalid input. Try again."
    else
        SUM=$((SUM + SCORE))
        COUNT=$((COUNT + 1))
    fi
done

echo "Exiting."
