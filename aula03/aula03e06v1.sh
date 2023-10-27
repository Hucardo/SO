#!/bin/bash
# This script opens 4 terminal windows using 'until' loop.

i=0
until [ $i -ge 4 ]; do
    xterm &
    i=$((i+1))
done
