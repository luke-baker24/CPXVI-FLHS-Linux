#5.2.1
apt install sudo

#5.2.2
echo "Defaults use_pty" >> /etc/sudoers

usermod -g 0 root

touch /var/log/sudo.log
echo 'Defaults logfile="/var/log/sudo.log"' >> /etc/sudoers

#1.4.4
printf "Th1s1sS3cur34Sur3!\nTh1s1sS3cur34Sur3!" | sudo passwd root

passwd -l root