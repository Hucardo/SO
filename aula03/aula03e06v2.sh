#!/bin/bash
# This script opens 4 terminal windows using 'for' loop with a numeric sequence.

for i in {1..4}; do
    xterm &
done
