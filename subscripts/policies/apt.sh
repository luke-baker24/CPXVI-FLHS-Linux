#Clean software archives
apt clean
apt autoclean

#Configuring automatic updates
sudo dpkg-reconfigure --priority=low unattended-upgrades

systemctl restart unattended-upgrades
systemctl enable unattended-upgrades

#Configuring sources.d
cp "$1/sources.list" /etc/apt/sources.list

sudo apt update
sudo apt upgrade