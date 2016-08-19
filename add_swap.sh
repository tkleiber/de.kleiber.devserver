#!/bin/sh

# size of swapfile in megabytes
swapsize=2100

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
  echo 'swapfile not found. Adding swapfile.'
  # allocate the disk space
  sudo fallocate -l ${swapsize}M /home/swapfile
  # only owner can read and write
  sudo chmod 600 /home/swapfile
  # sets up swap area in the file
  sudo mkswap /home/swapfile
  # enable file for paging and swapping
  # if this comes with "swapon failed: Invalid argument", check if the filesystem is supported for swap, xfs eg. is not
  sudo swapon /home/swapfile
  # mount the swapfile at boot
  echo '/home/swapfile none swap defaults 0 0' >> /etc/fstab
else
  echo 'swapfile found. No changes made.'
fi

# output results to terminal
df -h /home/swapfile
cat /proc/swaps
cat /proc/meminfo | grep Swap