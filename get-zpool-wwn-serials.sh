for s in $(zpool status $1| grep wwn | awk '{print $1}'); do echo "#######$s######"; smartctl -a /dev/disk/by-id/$s | grep -i serial; done
