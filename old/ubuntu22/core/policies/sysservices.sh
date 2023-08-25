#1.6.1.1
apt install apparmor -y

#1.6.1.3-1.6.1.4
aa-enforce /etc/apparmor.d/*
#aa-complain /etc/apparmor.d/*

systemctl enable apparmor
systemctl start apparmor

#5.1.1
systemctl enable cron

#Disabling control-alt-delete rebooting
systemctl mask ctrl-alt-del.target
systemctl daemon-reload 

#Initiating a session lock
apt install vlock -y

#Syncing time properly
echo "makestep 1 -1" >> /etc/chrony/chrony.conf
systemctl restart chrony.service

#4.2.1.1
apt install rsyslog -y

#4.2.1.2
systemctl enable rsyslog
systemctl start rsyslog

#4.2.2.1
echo "ForwardToSyslog=yes" | tee -a /etc/systemd/journald.conf

#4.2.2.2
echo "Compress=yes" | tee -a /etc/systemd/journald.conf

#4.2.2.3
echo "Storage=persistent" | tee -a /etc/systemd/journald.conf

systemctl restart journald
systemctl enable journald