#!/bin/bash

set -e
set -u
#set -x


array=()
IFS="
"

if ! type smartctl &> /dev/null; then
 echo "smartctl is not installed"
 exit 1
else
 SMARTCTL=$(which smartctl)
 for i in $(lsblk -io KNAME,TYPE 2> /dev/null | grep disk | awk '{print $1}')
  do
  a=$(echo "$i" | cut -d/ -f3)
  if [[ $($SMARTCTL -n idle -H /dev/$i | grep result) = "SMART overall-health self-assessment test result: FAILED" ]]; then
   array+=" Failure on $i;"
  else
   array[0]="1"
  fi
 done
fi

if [ ${#array[0]} -eq 1 ]; then
 echo 0
 exit 0
else
 printf '%s\n' "${array[@]}" | cut -c 2-
 exit 0
fi
