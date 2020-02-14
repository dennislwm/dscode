#!/bin/sh
#
# prefix sudo if user requires root access
#

# size of swapfile in gigabytes
swapsize=4

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
	echo 'swapfile not found. Adding swapfile.'
	fallocate -l ${swapsize}G /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo '/swapfile none swap sw 0 0' >> /etc/fstab
else
	echo 'swapfile found. No changes made.'
fi

echo '--------------------------------------------'
echo 'Check whether the swap space created or not?'
echo '--------------------------------------------'
swapon --show
free -m
