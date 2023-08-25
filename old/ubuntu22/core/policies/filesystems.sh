touch /etc/modprobe.d/settings.conf

#1.1.1.1
echo "install cramfs /bin/true" >> /etc/modprobe.d/settings.conf
rmmod cramfs

#1.1.1.2
echo "install freevxfs /bin/true" >> /etc/modprobe.d/settings.conf
rmmod freevxfs

#1.1.1.3
echo "install jffs2 /bin/true" >> /etc/modprobe.d/settings.conf
rmmod jffs2

#1.1.1.4
echo "install hfs /bin/true" >> /etc/modprobe.d/settings.conf
rmmod hfs

#1.1.1.5
echo "install hfsplus /bin/true" >> /etc/modprobe.d/settings.conf
rmmod hfsplus

#1.1.1.6
echo "install squashfs /bin/true" >> /etc/modprobe.d/settings.conf
rmmod squashfs

#1.1.1.7
echo "install udf /bin/true" >> /etc/modprobe.d/settings.conf
rmmod udf

#1.1.24
echo "install usb-storage /bin/true" >> /etc/modprobe.d/settings.conf
rmmod usb-storage

#3.4.1
echo "install dccp /bin/true" >> /etc/modprobe.d/settings.conf
rmmod dccp

#3.4.2
echo "install sctp /bin/true" >> /etc/modprobe.d/settings.conf
rmmod sctp

#3.4.3
echo "install rds /bin/true" >> /etc/modprobe.d/settings.conf
rmmod rds

#3.4.4
echo "install tipc /bin/true" >> /etc/modprobe.d/settings.conf
rmmod tipc

#1.1.2
echo "tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime 0 0" >> /etc/fstab

systemctl daemon-reload
systemctl restart tmp.mount

systemctl --now enable tmp.mount

#1.1.3
mount -o remount,nodev /tmp

#1.1.4
mount -o remount,nosuid /tmp

#1.1.5
mount -o remount,noexec /tmp

systemctl daemon-reload
systemctl restart tmp.mount

#1.1.6
echo "tmpfs /dev/shm tmpfs defaults,noexec,nodev,nosuid,seclabel 0 0" >> /etc/fstab

#1.1.7-1.1.9
mount -o remount,nosuid,nodev,noexec /dev/shm

#1.1.12-1.1.14
mount -o remount,nosuid,nodev,noexec /var/tmp

#1.1.18
mount -o remount,nodev /home

#1.1.22
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | xargs -I '{}' chmod a+t '{}'

#1.1.23
systemctl --now disable autofs
apt purge autofs