#!/bin/sh
#
# prefix sudo if user requires root access
#

#
# assert at least one argument
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit 1
fi

# assert valid IP
#
if [[ ! $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "Invalid ip address $1"
    exit 1
fi

#
# http://user:pass@dynupdate.no-ip.com/nic/update?hostname=tinode.myvnc.com&myip=192.0.2.25
#
# error: "nohost"
# success: "good 192.0.2.25"
# success: "nochg 192.0.2.25"
echo "curl http://${3}@dynupdate.no-ip.com/nic/update?hostname=${2}.myvnc.com&myip=${1}"
ret=$(curl http://${3}@dynupdate.no-ip.com/nic/update?hostname=${2}.myvnc.com&myip=${1})

echo '--------------------------------------------'
echo 'Check whether the ip address updated or not?'
echo '--------------------------------------------'
echo $ret
