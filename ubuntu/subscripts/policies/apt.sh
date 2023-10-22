#Clean software archives
apt clean
apt autoclean

#Configuring automatic updates
sudo dpkg-reconfigure --priority=low unattended-upgrades

echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";' > /etc/apt/apt.conf.d/20auto-upgrades

echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";' > /etc/apt/apt.conf.d/10periodic

#echo 'Unattended-Upgrade::Allowed-Origins {
#	"${distro_id}:${distro_codename}-security";
#	"${distro_id}:${distro_codename}-updates";
#};
#
#Unattended-Upgrade::Mail "root";
#
#Unattended-Upgrade::DevRelease "auto";
#
#Unattended-Upgrade::Remove-Unused-Dependencies "true"; 
#Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";' > /etc/apt/apt.conf.d/50unattended-upgrades
#
#echo '# Enable authenticated package updates
#DPkg::Options { "--force-confdef"; "--force-confold"; }
#Acquire::AllowInsecureRepositories "false";
#Acquire::AllowDowngradeToInsecureRepositories "false";
#
# Disable recommended packages
#APT::Install-Recommends "0";
#
# Disable source package downloads
#Acquire::Source-Symlinks "false";
#APT::Get::Download-Only "true";
#
# Enable GPG key checking
#APT::Get::AllowUnauthenticated "false";
#Acquire::gpgv::Options { "--ignore-time-conflict"; };' > /etc/apt/apt.conf.d/99final-scriptstuff
#
#echo '[DEFAULT]
#Prompt=lts' > /etc/update-manager/release-upgrades

systemctl restart unattended-upgrades
systemctl enable unattended-upgrades

#Configuring sources.d
cp "$1/sources.list" /etc/apt/sources.list

sudo apt update
sudo apt upgrade