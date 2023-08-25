#!/bin/bash

#ALWAYS REMOVE FTP USER

#/etc/passwd  Access: 644 Uid: 0/root Gid: 0/root
#/etc/shadow Access: 640 Uid: 0/root Gid: 42/shadow
#/etc/group Access: 644 Uid: 0/root Gid: 0/root
#/etc/gshadow Access: 640 Uid: 0/root Gid: 42/shadow
#/etc/passwd- Access: 644 Uid: 0/root Gid: 0/root
#/etc/shadow- Access: 640 Uid: 0/root Gid: 42/shadow
#/etc/group- Access: 644 Uid: 0/root Gid: 0/root
#/etc/gshadow- Access: 640 Uid: 0/root Gid:42/shadow
#/etc/crontab- Access: 600 Uid: 0/root Gid:0/root
#/etc/cron.<time>- Access: 700 Uid: 0/root Gid:0/root  (/etc/cron.d/ is the same here as well)

#fstab

#Logrotate config file?

echo "Hardening significant files and correcting file permissions..."




echo "Configuring Firewall..."

sudo sed -i 's/IPV6 *\n/IPV6 no\n/g' /etc/default/ufw 



#echo "Installing a virtual lockout..."

#apt-get install vlock -qq -y  #adding a virtual lockout



echo "Installing and enabling apparmor..."

apt-get install apparmor -qq -y > /dev/null #installing and enabling apparmor
systemctl enable apparmor.service > /dev/null #installing and enabling apparmor
systemctl start apparmor.service > /dev/null #installing and enabling apparmor



echo "Setting a disk full action and setting a certification policy..."

apt-get install libpam-pkcs11 -qq -q

sed -i 's/disk_full_action = *\n/disk_full_action = HALT\n/g' /etc/pam/_pkcs11/pam_pkcs11.conf
sed -i 's/certpolicy=*\n/certpolicy=ca,signature,ocsp_on,crl_auto\n/g' /etc/pam_pkcs11/pam_pkcs11.conf 



echo "Auditing grub..."

sudo sed -i 's/GRUB_CMDLINE_LINUX="*"\n/GRUB_CMDLINE_LINUX="audit=1"\n/g' /etc/default/grub 



echo "Enabling a screensaver lock..."

gsettings set org.gnome.desktop.screensaver lock-enabled true



#echo "Disabling kernel dumps..."

#systemctl disable kdump.service



echo "Locking accounts after 35 days of inactivity..."

useradd -D -f 35



#echo "???"

#echo "auth.*,authpriv.* /var/log/secure" | sudo tee -a /etc/rsyslog.d/50-default.conf > /dev/null
#echo "daemon.notice /var/log/messages" | sudo tee -a /etc/rsyslog.d/50-default.conf > /dev/null



#echo "Installing AIDE..."

#apt-get install aide aide-common

#aideinit
#mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db



#echo "Installing mfetp..."

#apt-get install mfetp









echo "Setting critical filesystem security settings..."

sudo sed -i 's/What=*\n/What=tmpfs\n/g' /etc/systemd/system/tmp.mount
sudo sed -i 's/Where=*\n/Where=\/tmp\n/g' /etc/systemd/system/tmp.mount #Check the regex on the /tmp
sudo sed -i 's/Type=*\n/Type=tmpfs\n/g' /etc/systemd/system/tmp.mount
sudo sed -i 's/Options=*\n/Options=mode=1777,strictatime,nosuid,nodev,noexec\n/g' /etc/systemd/system/tmp.mount

cp -v /usr/share/systemd/tmp.mount /etc/systemd/system/

mount -o remount,nodev /tmp
mount -o remount,nosuid /tmp
mount -o remount,noexec /tmp

#systemctl daemon-reload
systemctl restart tmp.mount
systemctl --now enable tmp.mount

echo "tmpfs /dev/shm tmpfs defaults,noexec,nodev,nosuid,seclabel 0 0" | tee -a /etc/fstab

mount -o remount,noexec,nodev,nosuid /dev/shm


echo "Disabling autofs..."

systemctl --now disable autofs
apt purge autofs



echo "?"

sed -ri 's/chmod\s+[0-7][0-7][0-7]\s+\$\{grub_cfg\}\.new/chmod 400 ${grub_cfg}.new/' /usr/sbin/grub-mkconfig
sed -ri 's/ && ! grep "\^password" \$\{grub_cfg\}.new >\/dev\/null//' /usr/sbin/grub-mkconfig


echo "Disabling avahi-daemon..."

systemctl stop avahi-daemon.service
systemctl stop avahi-daemon.socket

#echo "Purging gnome display manager 3..."

#apt purge gdm3



echo "Installing and configuring fail2ban..."

apt-get install fail2ban

cp /etc/fail2ban/fail.conf /etc/fail2ban/jail.local

service fail2ban restart


#Edit /etc/lightdm/lightdm.conf.d/100-custom-conf
#xserver-allow-tcp=true
