#!/bin/bash
return=($?)

hostname=hostname.com
ssh_port=2222
plex_port=32400
http_port=80

check() {
    if hash nc 2>/dev/null; then
        nc -z -w3 $hostname "$@"
    else
         echo "nc is not installed"
    fi
}

check $ssh_port
if [ $? -ne 0 ]; then
    echo "port check failed for sshport to $hostname"
else
    echo "all good"
fi
check $plex_port
if [ $? -ne 0 ]; then echo "bad check"; fi
check $http_port
if [ $? -ne 0 ]; then echo "bad check"; fi
