#1.5.3
prelink -ua
apt purge prelink

systemctl daemon-reload

#1.6.1.1
apt install apparmor

#1.6.1.3-1.6.1.4
aa-enforce /etc/apparmor.d/*
#aa-complain /etc/apparmor.d/*

#1.7.1, 1.7.4
rm /etc/motd

#1.7.2
echo "Ubuntu 20. Authorized uses only. All activity may be monitored and reported." > /etc/issue

#1.7.3
echo "Ubuntu 20. Authorized uses only. All activity may be monitored and reported." > /etc/issue.net

#5.1.1
systemctl --now enable cron

#Disabling control-alt-delete rebooting
systemctl mask ctrl-alt-del.target  > /dev/null
systemctl daemon-reload  > /dev/null


#Adding a user timeout - this is from old script
touch /etc/profile.d/99-terminal_tmout.sh 
echo "TMOUT=600" | tee /etc/profile.d/99-terminal_tmout.sh  > /dev/null


#Initiating a session lock
apt install vlock -y

echo "* hard maxlogins 10" >> /etc/security/limits.conf
echo "* hard core 0" >> /etc/security/limits.conf

#Syncing time properly
echo "makestep 1 -1" | tee -a /etc/chrony/chrony.conf
systemctl restart chrony.service
