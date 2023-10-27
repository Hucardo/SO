#!/bin/bash
# This script opens 4 terminal windows using 'for' loop with an array of values.

windows=("1" "2" "3" "4")

for i in "${windows[@]}"; do
    xterm &
done
