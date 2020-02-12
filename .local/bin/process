#!/bin/bash

if [ "$1" = "" ] ; then
  echo -n "Input process : "
  read process
else
  process=$1
fi
if [[ $(pidof $process) ]]; then
  # show process memory usage
  echo
  ps aux | grep $process | grep -v grep | awk 'BEGIN { sum=0 } {sum=sum+$6; } END {printf("[Totall memory used by process] : %s Mb\n",sum / 1024)}'
  # show memory usage
  echo
  free -m | awk 'NR==2{printf "[System memory status] : %s/%s Mb (%.2f%%)\n", $3,$2,$3*100/$2 }'

  # show process pid childs
  count=0
  for pid in $(pidof $process) ; do
    ((counter++))
  done
  echo -e "\n[Child process count] : $counter\n"
else
  echo "Process doesn't exist!"
  exit
fi
