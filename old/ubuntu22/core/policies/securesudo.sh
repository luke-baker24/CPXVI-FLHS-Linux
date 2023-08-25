#Making sure sudo is installed
apt install sudo

#No idea
echo "Defaults use_pty" >> /etc/sudoers

#Making sure that sudo is the root group with UID 0
usermod -g 0 root

#Logging sudo
touch /var/log/sudo.log
echo 'Defaults logfile="/var/log/sudo.log"' >> /etc/sudoers

#Making sure root is UID 0
usermod -g 0 root

#Giving root a password
printf "Th1s1sS3cur34Sur3!\nTh1s1sS3cur34Sur3!" | passwd root

#Locking the root account
passwd -l root