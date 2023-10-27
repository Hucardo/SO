#!/bin/bash
# This script does a very simple test for checking disk space.
partition_info=$(df -h | awk '{print $1, $5}' | grep % | grep -v Use | sort -n \
 | tail -1)
partition=$(echo $partition_info | awk '{print $1}')
space=$(echo $partition_info | awk '{print $2}' | cut -d "%" -f1 -)
echo "Partition with the least occupied space: $partition"
echo "Occupied space: $space%"

case $space in
  [0-6]*) # espaço < 70%
    Message="All OK."
    ;;
  [7-8]*) # 70% <= espaço < 90%
    Message="Cleaning out. One partition is $space % full."
    ;;
  9*) # 90% <= espaço < 99%
    Message="Better buy a new disk. One partition is $space % full."
    ;;
  99) # espaço = 99%
    Message="I'm drowning here! There's a partition at $space %!"
    ;;
  *) # espaço >= 100%
    Message="I seem to be running with a non-existent disk..."
    ;;
esac
echo $Message
