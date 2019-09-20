#!/bin/bash

echo "n
p
1


w
" | fdisk /dev/vdb

mkfs.ext4 /dev/vdb1
mkdir /data/
mount /dev/vdb1 /data
echo "/dev/vdb1               /data          ext4    defaults        0 0" >> /etc/fstab
