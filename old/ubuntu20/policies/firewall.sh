#3.5.1.1
apt install ufw

#3.5.1.2
apt purge iptables-persistent

#3.5.1.3
sudo ufw enable

#3.5.1.4
ufw allow in on lo
ufw allow out on lo
ufw deny in from 127.0.0.0/8
ufw deny in from ::1

#3.5.1.5
ufw allow out on all

#3.5.1.7
ufw default deny incoming
ufw default allow outgoing #should be deny according to CIS but that literally denies everything
ufw default deny routed

#note: configure more ports, also 3.5.1.7 may make backdoors harder to find
ufw allow git
ufw allow in http
ufw allow in https
ufw allow out 53
ufw logging on

#This is from old ubuntu script
sudo sed -i 's/UMASK *\n/UMASK 077\n/g' /etc/default/ufw  #giving users access only to their own files