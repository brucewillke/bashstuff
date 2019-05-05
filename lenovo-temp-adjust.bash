#!/bin/bash

my_array=()
while IFS= read -r line; do
my_array+=( "$line" )
done < <( for a in $(fdisk -l | grep Disk | grep '/dev/sd' | awk '{print $2}' | tr -d ':'); do smartctl -a $a | grep -i temp; done | awk '{print $10}' | grep -E "[30..40]" | sort -nr | head -n1)

for each in "${my_array[@]}"
do
  LIMIT=40
  if [ "$each" -gt "$LIMIT" ]
  then
    echo "########raising fans"; /usr/bin/python /root/lenovo-sa120-fanspeed-utility/fancontrol.py 3
   else
     echo "#############lowering fans"; /usr/bin/python /root/lenovo-sa120-fanspeed-utility/fancontrol.py 1
   fi
done
