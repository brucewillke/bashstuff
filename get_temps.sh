#!/bin/bash

declare -a temps=()

function find_disks {
    fdisk -l | grep Disk | grep '/dev/sd' | awk '{print $2}' | tr -d ':'
}

function get_temps {
    #hddtemp -n $1
    sudo smartctl -l scttempsts $1 | grep -i current | grep -o '[0-9]\+'
}

DISKS=$(find_disks)

for DEVICE in $DISKS
do
    for temp in $(get_temps $DEVICE)
    do
    echo "$temp $DEVICE"
    done
done

