# exit immediately if a command exits with a non-zero status.
set -e
# activate debugging from here
set -x

if [ -f /etc/disk_added_date ] ; then
   echo "disk already added so exiting."
   exit 0
fi

# show diskspace of the logical volume before adding the disk
df -h /dev/mapper/linux-root

# partitioning the disk
sudo fdisk -u /dev/sdb <<EOF
n
p



t

8e
w
EOF

# initialize the partition for use by logical volume manager
sudo pvcreate /dev/sdb1
# add the partition to volume group linux
sudo vgextend linux /dev/sdb1
# increase the size of the logical volume /dev/mapper/linux-root
sudo lvextend --extents +51199 --resizefs /dev/mapper/linux-root
# mark that the disk was added
date > /etc/disk_added_date

# show diskspace of the logical volume after adding the disk
df -h /dev/mapper/linux-root