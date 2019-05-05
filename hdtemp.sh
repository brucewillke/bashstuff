for a in $(fdisk -l | grep Disk | grep '/dev/sd' | awk '{print $2}' | tr -d ':'); do smartctl -a $a; done | grep -i temp
