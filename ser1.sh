#!/bin/sh
sudo umount /dev/sdb1
sudo fdisk /dev/sdb1 <<EOF
o
n
p
1


t
83
a
1
w
EOF
sudo mkfs.ext2 -F /dev/sdb1
echo "Here ..................................."
sudo mkdir -p /mnt/sdb1
sudo mount /dev/sdb1 /mnt/sdb1
wget -C  http://ftp.be.debian.org/pub/linux/utils/boot/syslinux/4.xx/syslinux-4.04.tar.bz2
tar xvjf syslinux*.tar.bz2
cat syslinux-4.04/mbr/mbr.bin >/mnt/sdb
sudo syslinux-4.04/extlinux/extlinux -i /mnt/sdb1
cat > /mnt/sdb1/extlinux.conf <<EOF
DEFALUT core
LABEL core
KERNEL /tce/boot/vmlinuz
INITRD /tce/boot/core.gz
APPEND quiet waitusb=5:UUID="84abaf68-a2c0-484b-9eb8-16d2a5ec4b46" tce=UUID="84abaf68-a2c0-484b-9eb8-16d2a5ec4b46"
EOF
sudo cp /mnt/sda1/tce/boot/extlinux/* /mnt/sdb1/
sudo mkdir -p /mnt/sdb1/tce/boot
sudo cp /mnt/sda1/tce/boot/core.gz /mnt/sdb1/tce/boot/
sudo cp /mnt/sda1/tce/boot/vmlinuz /mnt/sdb1/tce/boot/
sudo mkdir -p /mnt/sdb1/tce/www
cat > /home/tc/helow.txt <<EOF
Hellow world !
EOF

sudo find hellow | cpio -o -H newc | gzip -9 > /mnt/sdb1/tce/www/app.gz

tce-load -wi firefox-ESR python python-pip firmware openbox Xorg lighttpd syslinux dnsmasq

pip install enum34 keyboard pynput pyping python-xlib pyudev six==1.12.0

tce-load -wi firmware-i915 firmware-amdgpu firmware-amd-ucode firmware-nvidia firmware-radeon

sudo mkdir -p /home/tc/base
sudo mkdir -p /home/tc/base/home /home/tc/base/tmp
sudo mkdir -p /home/tc/base/tmp/builtin
sudo mkdir -p /home/tc/base/tmp/builtin/optional
sudo cp /mnt/sda1/tce/onboot.lst /home/tc/base/tmp/builtin
sudo cp -R /mnt/sda1/tce/optional/* /home/tc/base/tmp/builtin/optional
sudo mkdir -p /home/tc/base/home/tc
sudo cat > /home/tc/base/home/tc/.setbackground <<EOF
#!/bin/sh
hsetroot
EOF
sudo mkdir -p /home/tc/base/home/tc/.local /home/tc/base/home/tc/.X.d
sudo mkdir -p /home/tc/base/home/tc/.local/bin /home/tc/base/home/tc/.local/lib
sudo mkdir -p /home/tc/base/home/tc/.local/lib/python2.7
sudo mkdir -p /home/tc/base/home/tc/.local/lib/python2.7/site-packages
sudo cp -R /usr/local/lib/python2.7/site-packages/* /home/tc/base/home/tc/.local/lib/python2.7/site-packages
sudo cat > /home/tc/base/home/tc/.X.d/00-background <<EOF
hsetroot
EOF
sudo cat > /home/tc/base/home/tc/.X.d/99-ff <<EOF
exec firefox
EOF
sudo cat > /home/tc/base/home/tc/.X.d/11-resolution <<EOF
xrandr-s 1024x768
EOF
sudo find base | cpio -o -H newc | gzip -9 > /mnt/sdb1/tce/www/base.gz 

} 
