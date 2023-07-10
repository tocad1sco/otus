mdadm --zero-superblock --force /dev/sd{c,d}
mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sd{c,d}
mkdir /etc/mdadm
touch /etc/mdadm/mdadm.conf
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf 
mdadm --detail --scan --verbose | awk '/ARRAY/{print}' >> /etc/mdadm/mdadm.conf
