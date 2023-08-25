#6.1.2
chown root:root /etc/passwd
chmod u-x,go-wx /etc/passwd

#6.1.3
chown root:root /etc/passwd-
chmod u-x,go-wx /etc/passwd-

#6.1.4
chown root:root /etc/group
chmod u-x,go-wx /etc/group

#6.1.5
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-

#6.1.6
chown root:root /etc/shadow
chown root:shadow /etc/shadow

chmod u-x,g-wx,o-rwx /etc/shadow

#6.1.7
chown root:root /etc/shadow-
chown root:shadow /etc/shadow-

chmod u-x,g-wx,o-rwx /etc/shadow-

#6.1.8
chown root:root /etc/gshadow
chown root:shadow /etc/gshadow

chmod u-x,g-wx,o-rwx /etc/gshadow

#6.1.9
chown root:root /etc/gshadow-
chown root:shadow /etc/gshadow-

chmod u-x,g-wx,o-rwx /etc/gshadow-

#1.7.5
chown root:root $(readlink -e /etc/issue)
chmod u-x,go-wx $(readlink -e /etc/issue)

#1.7.6
chown root:root $(readlink -e /etc/issue.net)
chmod u-x,go-wx $(readlink -e /etc/issue.net)

#5.1.2
chown root:root /etc/crontab
chmod og-rwx /etc/crontab

#5.1.3
chown root:root /etc/cron.hourly/
chmod og-rwx /etc/cron.hourly/

#5.1.4
chown root:root /etc/cron.daily/
chmod og-rwx /etc/cron.daily/

#5.1.5
chown root:root /etc/cron.weekly/
chmod og-rwx /etc/cron.weekly/

#5.1.6
chown root:root /etc/cron.monthly/
chmod og-rwx /etc/cron.monthly/

#5.1.7
chown root:root /etc/cron.d/
chmod og-rwx /etc/cron.d/

#5.1.8
rm /etc/cron.deny
touch /etc/cron.allow

chmod g-wx,o-rwx /etc/cron.allow
chown root:root /etc/cron.allow

echo "root" | tee /etc/cron.allow

#5.1.9
rm /etc/at.deny
touch /etc/at.allow

chmod g-wx,o-rwx /etc/at.allow
chown root:root /etc/at.allow

#1.4.3
chown root:root /boot/grub/grub.cfg
chmod u-wx,go-rwx /boot/grub/grub.cfg


#Additional file perms
chown root:root /sbin/


#Pulled from old Ubuntu script
find /lib /usr/lib /lib64 ! -group root -type d -exec chgrp root '{}' \; #making sure root owns system library directories
find /lib /usr/lib /lib64 ! -user root -type d -exec stat -c "%n %U" '{}' \; 
find /lib /usr/lib /lib64 ! -group root -type f -exec chgrp root '{}' \;

find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -user root -type d -exec chown root '{}' \;
find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -perm /022 -type d -exec chmod -R 755 '{}' \;
find /lib /lib64 /usr/lib -perm /022 -type f -exec chmod 755 "%n %a" '{}' \; #iirc this one was commented/sketchy fsr
find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -group root -type d -exec chgrp root '{}' \;

find /bin /sbin /usr/bin /usr/local/bin /usr/local/sbin -perm /022 -type f -exec chmod 755 '{}' \;
find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -user root -type f -exec chown root '{}' \;
find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -group root -type f ! -perm /2000 -exec chgrp root '{}' \;

#4.2.3
find /var/log -type f -exec chmod g-wx,o-rwx "{}" + -o -type d -exec chmod gw,o-rwx "{}" +

chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

find /lib /usr/lib /lib64 ! -user root -type f -exec chown root '{}' \;
find /lib /lib64 /usr/lib -perm /022 -type d -exec chmod 755 '{}' \;

#Files that should probably be changed
chown root:root /etc/security/opasswd
chmod u-x,go-wx /etc/security/opasswd

chown root:root /etc/security/opasswd-
chmod u-x,go-wx /etc/security/opasswd-

#From the compliance checker
chmod 0750 /var/log

find /var/log -perm /137 -type f -exec chmod 640 '{}' \;

exit

#Pulled from the old ubuntu script
chmod 440 /proc/cmdline
#chmod 440 /etc/system.d 
#chmod 440 /etc/rc.* 
chmod 440 /etc/init.* 

chmod 644 /etc/profile 
#chmod 440 ~/.bash_profile 
#chmod 440 ~/.bash_login 
#chmod 440 ~/.profile 
#chmod 444 /etc/bash.bashrc 
chmod 644 /etc/profile.d 

chmod 440 /etc/hosts 
chmod 644 /etc/resolv.conf 

chmod 644 /etc/passwd 
chmod 640 /etc/shadow  
chmod 640 /etc/group 
chmod 640 /etc/gshadow 

chmod 440 /etc/pam.d 

chmod 0640 /var/log/syslog

chmod 0750 /var/log

chmod 440 /etc/sudoers

#chmod g-wx,o-rwx /etc/at.allow
#chown root:root /etc/at.allow

chown root:root /etc/passwd
chmod u-x,go-wx /etc/passwd

chown root:root /etc/passwd-
chmod u-x,go-wx /etc/passwd-

chown root:root /etc/group
chmod u-x,go-wx /etc/group

chown root:root /etc/group-
chmod u-x,go-wx /etc/group-

chown root:root /etc/shadow
chown root:shadow /etc/shadow
chmod u-x,g-wx,o-rwx /etc/shadow

chown root:root /etc/shadow-
chown root:shadow /etc/shadow-
chmod u-x,g-wx,o-rwx /etc/shadow-

chown root:root /etc/gshadow
chown root:shadow /etc/gshadow
chmod u-x,g-wx,o-rwx /etc/gshadow

chown root:root /etc/gshadow-
chown root:shadow /etc/gshadow-
chmod u-x,g-wx,o-rwx /etc/gshadow-

chown root:root $(readlink -e /etc/issue)
chmod u-x,go-wx $(readlink -e /etc/issue)


chown root:root $(readlink -e /etc/issue.net)
chmod u-x,go-wx $(readlink -e /etc/issue.net)

chown root:root /etc/crontab
chmod og-rwx /etc/crontab

chown root:root /etc/cron.hourly/
chmod og-rwx /etc/cron.hourly/

chown root:root /etc/cron.daily/
chmod og-rwx /etc/cron.daily/

chown root:root /etc/cron.weekly/
chmod og-rwx /etc/cron.weekly/

chown root:root /etc/cron.monthly/
chmod og-rwx /etc/cron.monthly/

chown root:root /etc/cron.d/
chmod og-rwx /etc/cron.d/

#chmod g-wx,o-rwx /etc/cron.allow
#chown root:root /etc/cron.allow

chgrp adm /var/log/syslog 
chgrp syslog /var/log 

chown root /var/log 
chown syslog /var/log/syslog
