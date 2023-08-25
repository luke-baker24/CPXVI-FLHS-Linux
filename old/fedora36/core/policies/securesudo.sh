#5.2.1
dnf install sudo

#5.2.2
echo "Defaults use_pty" >> /etc/sudoers

usermod -g 0 root

touch /var/log/sudo.log
echo 'Defaults logfile="/var/log/sudo.log"' >> /etc/sudoers
