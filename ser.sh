#!/bin/sh

cat > /etc/udhcpd.conf <<EOF
start 172.16.2.0
end 172.16.6.0
interface eth0
opt subnet 255.255.0.0
opt tftp 172.16.1.0
opt bootfile pxelinux.0
siaddr 172.16.1.0
boot_file pxelinux.0
EOF

tftpdir=$(sudo find /mnt -type d -name pxe-boot)
httpdir=$(sudo find /mnt -type d -name www)

mkdir /var/log/lighttpd

cat > /usr/local/etc/lighttpd.conf <<EOF
server.port = 80
server.document-root = "$httpdir"
accesslog.filename = "/var/log/lighttpd/access.log"
server.errorlog = "/var/log/lighttpd/error.log"
mime.type.assign = ( 	".html" => "text/html",
			".txt" => "text/plain" )
EOF



stype=$(cat /proc/cmdline | grep 'stype=.' | cut -f 2 -d "=")
if [ stype = s ]; then
	snum=$(cat /proc/cmdline | grep 'snum=.\+' | cut -f 2 -d "=")
fi

if [ stype = s ]; then
	sudo ifconfig eth0 172.16.1.$snum
	sudo lighttpd -f /usr/local/etc/lighttpd/lighttpd.conf

fi

if [ stype = p ]; then
	sudo udhcpd
	sudo udpsvd 0.0.0.0 69 tftpd $tftpdir &
fi
EOF

