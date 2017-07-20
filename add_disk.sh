# exit immediately if a command exits with a non-zero status.
set -e
# activate debugging from here
set -x

if [ -f /etc/disk_added_date ] ; then
   echo "disk already added so exiting."
   exit 0
fi

# show diskspace of the logical volume before adding the disk
df -h /dev/mapper/VolGroup00-LogVol00

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
# list volume groups
sudo vgs
# add the partition to volume group
sudo vgextend VolGroup00 /dev/sdb1
# increase the size of the logical volume
sudo lvextend --extents +6399 --resizefs /dev/mapper/VolGroup00-LogVol00
# mark that the disk was added
date > /etc/disk_added_date

# show diskspace of the logical volume after adding the disk
df -h /dev/mapper/VolGroup00-LogVol00

# change timezone
timedatectl set-timezone Europe/Berlin
