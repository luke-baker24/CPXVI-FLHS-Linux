#6.1.2
chown root:root /etc/passwd
chmod 644 /etc/passwd

#6.1.3
chown root:root /etc/passwd-
chmod 644 /etc/passwd-

#6.1.4
chown root:root /etc/group
chmod 644 /etc/group

#6.1.5
chown root:root /etc/group-
chmod 644 /etc/group-

#6.1.6
#chown root:root /etc/shadow
chown root:shadow /etc/shadow

chmod 640 /etc/shadow

#6.1.7
#chown root:root /etc/shadow-
chown root:shadow /etc/shadow-

chmod 640 /etc/shadow-

#6.1.8
#chown root:root /etc/gshadow
chown root:shadow /etc/gshadow

chmod 640 /etc/gshadow

#6.1.9
#chown root:root /etc/gshadow-
chown root:shadow /etc/gshadow-

chmod 640 /etc/gshadow-

#1.7.5
chown root:root $(readlink -e /etc/issue)
chmod 644 $(readlink -e /etc/issue)

#1.7.6
chown root:root $(readlink -e /etc/issue.net)
chmod 644 $(readlink -e /etc/issue.net)

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

chown root:root /etc/cron.allow
chmod g-wx /etc/cron.allow
chmod o-rwx /etc/cron.allow

#5.1.9
rm /etc/at.deny
touch /etc/at.allow

chown root:root /etc/at.allow
chmod g-wx,o-rwx /etc/at.allow

#1.4.3
chown root:root /boot/grub/grub.cfg
chmod 400 /boot/grub/grub.cfg


#Additional file perms
chown root:root /sbin/



chmod 440 /proc/cmdline
chmod 440 /etc/system.d 
chmod 440 /etc/rc.* 
chmod 440 /etc/init.* 

chmod 644 /etc/profile 
chmod 444 /etc/bash.bashrc 
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

chmod g-wx /etc/at.allow
chmod o-rwx /etc/at.allow
chown root:root /etc/at.allow

chown root:root $(readlink -e /etc/issue)
chmod 644 $(readlink -e /etc/issue)


chown root:root $(readlink -e /etc/issue.net)
chmod 644 $(readlink -e /etc/issue.net)

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

chmod g-wx /etc/cron.allow
chmod o-rwx /etc/cron.allow
chown root:root /etc/cron.allow

chgrp adm /var/log/syslog 
chgrp syslog /var/log 

chown root /var/log 
chown syslog /var/log/syslog


#Files that should probably be changed
chown root:root /etc/security/opasswd
chmod 644 /etc/security/opasswd

chown root:root /etc/security/opasswd-
chmod 644 /etc/security/opasswd-






exit




#From the compliance checker
chmod 0750 /var/log



#Pulled from old Ubuntu script
find /lib /usr/lib /lib64 ! -group root -type d -exec chgrp root '{}' \; #making sure root owns system library directories
find /lib /usr/lib /lib64 ! -user root -type d -exec stat -c "%n %U" '{}' \; 
find /lib /usr/lib /lib64 ! -group root -type f -exec chgrp root '{}' \;

find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -user root -type d -exec chown root '{}' \;
find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -perm /022 -type d -exec chmod -R 755 '{}' \;
find /lib /lib64 /usr/lib -perm /022 -type f -exec chmod 755 "%n %a" '{}' \;
find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -group root -type d -exec chgrp root '{}' \;

find /bin /sbin /usr/bin /usr/local/bin /usr/local/sbin -perm /022 -type f -exec chmod 755 '{}' \;
find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -user root -type f -exec chown root '{}' \;
find /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin ! -group root -type f ! -perm /2000 -exec chgrp root '{}' \;

#4.2.3
find /var/log -type f -exec chmod g-wx,o-rwx "{}" + -o -type d -exec chmod gw,o-rwx "{}" +

chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

find /lib /usr/lib /lib64 ! -user root -type f -exec chown root '{}' \;
find /lib /lib64 /usr/lib -perm /022 -type d -exec chmod 755 '{}' \;

find /var/log -perm /137 -type f -exec chmod 640 '{}' \;

echo "root" > /etc/at.allow
echo "root" > /etc/cron.allow
echo "ALL: localhost" > /etc/hosts.allow
echo "ALL: PARANOID" > /etc/hosts.deny

awk -F: '($1!~/(halt|sync|shutdown)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) {print $6}' /etc/passwd | while read -r dir; do
    if [ -d "$dir" ]; then
        dirperm=$(stat -L -c "%A" "$dir")
        if [ "$(echo "$dirperm" | cut -c6)" != "-" ] || [ "$(echo "$dirperm" | cut -c8)" != "-" ] || [ "$(echo "$dirperm" | cut -c9)" != "-" ] || [ "$(echo "$dirperm" | cut -c10)" != "-" ]; then
            chmod g-w,o-rwx "$dir"
        fi
    fi
done

awk -F: '($1!~/(halt|sync|shutdown)/ && $7!~/^(\/usr)?\/sbin\/nologin(\/)?$/ && $7!~/(\/usr)?\/bin\/false(\/)?$/) { print $1 " " $6 }' | while read -r user dir; do
    if [ -d "$dir" ]; then
        for file in "$dir"/.*; do
            if [ ! -h "$file" ] && [ -f "$file" ]; then
                fileperm=$(stat -L -c "%A" "$file")
                if [ "$(echo "$fileperm" | cut -c6)" != "-" ] || [ "$(echo "$fileperm" | cut -c9)" != "-" ]; then
                    chmod go-w "$file"
                fi
            fi
        done
    fi
done