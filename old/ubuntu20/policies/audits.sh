modify_config_setting()
{
    cat $1 | grep -vP "^$2 = " | tee $1 
    echo "$2 = $3" >> $1
}

#4.1.1.1
apt install auditd -y

#4.1.1.2
systemctl enable auditd
systemctl start auditd

#4.1.1.3
#sudo sed -i 's/GRUB_CMDLINE_LINUX="*"/GRUB_CMDLINE_LINUX="* audit=1"/' /etc/default/grub

#4.1.1.4
#sudo sed -i 's/GRUB_CMDLINE_LINUX="*"/GRUB_CMDLINE_LINUX="* audit_backlog_limit=8192"/' /etc/default/grub
#update-grub

#4.1.2.2
modify_config_setting /etc/audit/auditd.conf max_log_file_action keep_logs

#4.1.2.3
modify_config_setting /etc/audit/auditd.conf space_left_action email
modify_config_setting /etc/audit/auditd.conf action_mail_acct root
modify_config_setting /etc/audit/auditd.conf admin_space_left_action halt

#4.1.3
touch /etc/audit/rules.d/audit.rules

auditctl -a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change  
auditctl -a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time- change  
auditctl -a always,exit -F arch=b64 -S clock_settime -k time-change  
auditctl -a always,exit -F arch=b32 -S clock_settime -k time-change  
auditctl -w /etc/localtime -p wa -k time-change 

#4.1.4
auditctl -w /etc/group -p wa -k identity  
auditctl -w /etc/passwd -p wa -k identity  
auditctl -w /etc/gshadow -p wa -k identity  				
auditctl -w /etc/shadow -p wa -k identity  
auditctl -w /etc/security/opasswd -p wa -k identity  

#4.1.5
auditctl -a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale  
auditctl -a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale  
auditctl -w /etc/issue -p wa -k system-locale  
auditctl -w /etc/issue.net -p wa -k system-locale  
auditctl -w /etc/hosts -p wa -k system-locale  
auditctl -w /etc/network -p wa -k system-locale  

#4.1.6
auditctl -w /etc/apparmor/ -p wa -k MAC-policy  
auditctl -w /etc/apparmor.d/ -p wa -k MAC-policy  

#4.1.7
auditctl -w /var/log/tallylog -p wa -k logins 
auditctl -w /var/log/faillog -p wa -k logins 
auditctl -w /var/log/lastlog -p wa -k logins 

#4.1.8
auditctl -w /var/run/utmp -p wa -k logins 
auditctl -w /var/log/btmp -p wa -k logins 
auditctl -w /var/log/wtmp -p wa -k logins 

#4.1.9
auditctl -a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid\>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid\>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid\>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid\>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid\>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid\>=1000 -F auid!=4294967295 -k perm_mod

#4.1.10
auditctl -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid\>=1000 -F auid!=4294967295 -k access
auditctl -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid\>=1000 -F auid!=4294967295 -k access
auditctl -a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid\>=1000 -F auid!=4294967295 -k access
auditctl -a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid\>=1000 -F auid!=4294967295 -k access

#4.1.12
auditctl -a always,exit -F arch=b64 -S mount -F auid\>=1000 -F auid!=4294967295 -k mounts
auditctl -a always,exit -F arch=b32 -S mount -F auid\>=1000 -F auid!=4294967295 -k mounts

#4.1.13
auditctl -a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid\>=1000 -F auid!=4294967295 -k delete
auditctl -a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid\>=1000 -F auid!=4294967295 -k delete

#4.1.14
auditctl -w /etc/sudoers -p wa -k scope
auditctl -w /etc/sudoers.d/ -p wa -k scope

#4.1.15
auditctl -a always,exit -F arch=b64 -C euid!=uid -F euid=0 -Fauid\>=1000 -F auid!=4294967295 -S execve -k actions
auditctl -a always,exit -F arch=b32 -C euid!=uid -F euid=0 -Fauid\>=1000 -F auid!=4294967295 -S execve -k actions

#4.1.16
auditctl -w /sbin/insmod -p x -k modules
auditctl -w /sbin/rmmod -p x -k modules
auditctl -w /sbin/modprobe -p x -k modules
auditctl -a always,exit -F arch=b64 -S init_module -S delete_module -k modules


#Ones pulled from the old Ubuntu script
auditctl -w /var/log/tallylog -p wa -k logins
auditctl -w /var/log/faillog -p wa -k logins
auditctl -w /var/log/lastlog -p wa -k logins
auditctl -w /etc/passwd -p wa -k usergroup_modification
auditctl -w /etc/group -p wa -k usergroup_modification
auditctl -w /bin/fdisk -p wa -k fdisk
auditctl -w /etc/shadow -p wa -k usergroup_modification
auditctl -w /etc/gshadow -p wa -k usergroup_modification
auditctl -w /etc/security/opasswd -p wa -k usergroup_modification
auditctl -w /var/run/wtmp -p wa -k logins
auditctl -w /var/log/btmp -p wa -k logins
auditctl -w /var/log/wtmp -p wa -k logins
auditctl -w /sbin/modprobe -p wa -k modules
auditctl -w /bin/kmod -p wa -k modules
auditctl -w /var/log/sudo.log -p wa -k maitenance

auditctl -a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=1000 -F auid!=4294967295 -k perm_chng
auditctl -a always,exit -F path=/usr/bin/newgrp -F perm=x -F auid>=1000 -F auid!=4294967295 -k priv_cmd
auditctl -a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=1000 -F auid!=-1 -k perm_chng
auditctl -a always,exit -F path=/sbin/apparmor_parser -F perm=x -F auid>=1000 -F auid!=4294967295 -k perm_chng
auditctl -a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=1000 -F auid!=-1 -k perm_chng
auditctl -a always,exit -F path=/usr/bin/passwd -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged-passwd
auditctl -a always,exit -F path=/sbin/unix_update -F perm=x -F auid>=1000 -F auid!=-1 -k privileged-unix-update
auditctl -a always,exit -F path=/sbin/pam_timestamp_check -F perm=x -F auid>=1000 -F auid!=-4294967295 -k privileged-pam_timestamp_check
auditctl -a always,exit -F path=/usr/bin/crontab -F perm=x -F auid>=1000 -F auid!=-1 -k privileged-crontab
auditctl -a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-usermod
auditctl -a always,exit -F path=/usr/sbin/chage -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-chage
auditctl -a always,exit -F path=/usr/bin/gpasswd -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-gpasswd
auditctl -a always,exit -F path=/usr/bin/chfn -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-chfn
auditctl -a always,exit -F path=/bin/su -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-priv_change
auditctl -a always,exit -F path=/usr/bin/umount -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-umount
auditctl -a always,exit -F path=/usr/bin/mount -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-mount
auditctl -a always,exit -F path=/usr/bin/chsh -F perm=x -F auid>=1000 -F auid!=4294967295 -k priv_cmd
auditctl -a always,exit -F path=/usr/bin/sudoedit -F perm=x -F auid>=1000 -F auid!=4294967295 -k priv_cmd
auditctl -a always,exit -F path=/usr/bin/sudo -F perm=x -F auid>=1000 -F auid!=4294967295 -k priv_cmd


auditctl -a always,exit -F arch=b32 -S delete_module -F auid>=1000 -F auid!=4294967295 -k module_chng
auditctl -a always,exit -F arch=b64 -S delete_module -F auid>=1000 -F auid!=4294967295 -k module_chng

auditctl -a always,exit -F arch=b32 -S finit_module -F auid>=1000 -F auid!=-1 -k module_chng
auditctl -a always,exit -F arch=b64 -S finit_module -F auid>=1000 -F auid!=-1 -k module_chng

auditctl -a always,exit -F arch=b32 -S init_module -F auid>=1000 -F auid!=4294967295 -k module_chng
auditctl -a always,exit -F arch=b64 -S init_module -F auid>=1000 -F auid!=4294967295 -k module_chng

auditctl -a always,exit -F arch=b32 -S delete_module -F key=modules
auditctl -a always,exit -F arch=b64 -S delete_module -F key=modules

auditctl -a always,exit -F arch=b64 -S rename -F auid>=1000 -F auid!=4294967295 -k delete
auditctl -a always,exit -F arch=b32 -S rename -F auid>=1000 -F auid!=4294967295 -k delete

auditctl -a always,exit -F arch=b64 -S renameat -F auid>=1000 -F auid!=4294967295 -k delete
auditctl -a always,exit -F arch=b32 -S renameat -F auid>=1000 -F auid!=4294967295 -k delete

auditctl -a always,exit -F arch=b64 -S unlink -F auid>=1000 -F auid!=4294967295 -k delete
auditctl -a always,exit -F arch=b32 -S unlink -F auid>=1000 -F auid!=4294967295 -k delete

auditctl -a always,exit -F arch=b64 -S unlinkat -F auid>=1000 -F auid!=4294967295 -k delete
auditctl -a always,exit -F arch=b32 -S unlinkat -F auid>=1000 -F auid!=4294967295 -k delete

auditctl -a always,exit -F arch=b64 -S fchownat -F auid>=1000 -F auid!=4294967295 -k perm_chng
auditctl -a always,exit -F arch=b32 -S fchownat -F auid>=1000 -F auid!=4294967295 -k perm_chng

auditctl -a always,exit -F arch=b64 -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_chng
auditctl -a always,exit -F arch=b32 -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_chng

auditctl -a always,exit -F arch=b64 -S chown -F auid>=1000 -F auid!=4294967295 -k perm_chng
auditctl -a always,exit -F arch=b32 -S chown -F auid>=1000 -F auid!=4294967295 -k perm_chng

auditctl -a always,exit -F arch=b64 -S fchown -F auid>=1000 -F auid!=4294967295 -k perm_chng
auditctl -a always,exit -F arch=b32 -S fchown -F auid>=1000 -F auid!=4294967295 -k perm_chng

auditctl -a always,exit -F arch=b64 -S chmod -F auid>=1000 -F auid!=4294967295 -k perm_chng
auditctl -a always,exit -F arch=b32 -S chmod -F auid>=1000 -F auid!=4294967295 -k perm_chng

auditctl -a always,exit -F arch=b64 -S fchmod -F auid>=1000 -F auid!=4294967295 -k perm_chng
auditctl -a always,exit -F arch=b32 -S fchmod -F auid>=1000 -F auid!=4294967295 -k perm_chng

auditctl -a always,exit -F arch=b64 -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_chng
auditctl -a always,exit -F arch=b32 -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_chng

auditctl -a always,exit -F arch=b32 -S delete_module -k modules
auditctl -a always,exit -F arch=b64 -S delete_module -k modules

auditctl -a always,exit -F arch=b32 -S lsetxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b32 -S lsetxattr -F auid=0 -k perm_mod
auditctl -a always,exit -F arch=b64 -S lsetxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S lsetxattr -F auid=0 -k perm_mod

auditctl -a always,exit -F arch=b32 -S setxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b32 -S setxattr -F auid=0 -k perm_mod
auditctl -a always,exit -F arch=b64 -S setxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S setxattr -F auid=0 -k perm_mod

auditctl -a always,exit -F arch=b32 -S fsetxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b32 -S fsetxattr -F auid=0 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fsetxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fsetxattr -F auid=0 -k perm_mod

auditctl -a always,exit -F arch=b32 -S removexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b32 -S removexattr -F auid=0 -k perm_mod
auditctl -a always,exit -F arch=b64 -S removexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S removexattr -F auid=0 -k perm_mod

auditctl -a always,exit -F arch=b32 -S lremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b32 -S lremovexattr -F auid=0 -k perm_mod
auditctl -a always,exit -F arch=b64 -S lremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S lremovexattr -F auid=0 -k perm_mod

auditctl -a always,exit -F arch=b32 -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b32 -S fremovexattr -F auid=0 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod
auditctl -a always,exit -F arch=b64 -S fremovexattr -F auid=0 -k perm_mod

auditctl -a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -F key=execpriv
auditctl -a always,exit -F arch=b32 -S execve -C uid!=egid -F egid=0 -F key=execpriv
auditctl -a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -F key=execpriv
auditctl -a always,exit -F arch=b64 -S execve -C uid!=egid -F egid=0 -F key=execpriv

auditctl -a always,exit -F arch=b32 -S open -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b32 -S open -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S open -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S open -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access

auditctl -a always,exit -F arch=b32 -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b32 -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access

auditctl -a always,exit -F arch=b32 -S truncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b32 -S truncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S truncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S truncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access

auditctl -a always,exit -F arch=b32 -S openat -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b32 -S openat -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S openat -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S openat -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access

auditctl -a always,exit -F arch=b32 -S creat -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b32 -S creat -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S creat -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S creat -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access

auditctl -a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access
auditctl -a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access 

auditctl -a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change 
auditctl -a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time- change 

auditctl -a always,exit -F arch=b64 -S clock_settime -k time-change 
auditctl -a always,exit -F arch=b32 -S clock_settime -k time-change 
auditctl -w /etc/localtime -p wa -k time-change
			
auditctl -w /etc/group -p wa -k identity 
auditctl -w /etc/passwd -p wa -k identity 
auditctl -w /etc/gshadow -p wa -k identity 				
auditctl -w /etc/shadow -p wa -k identity 
auditctl -w /etc/security/opasswd -p wa -k identity 

auditctl -w /etc/apparmor/ -p wa -k MAC-policy 
auditctl -w /etc/apparmor.d/ -p wa -k MAC-policy 

#Policies ripped from the scan
echo "-a always,exit -F path=/bin/su -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-priv_change 
-a always,exit -F path=/usr/bin/chfn -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-chfn 
-a always,exit -F path=/usr/bin/mount -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-mount 
-a always,exit -F path=/usr/bin/umount -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-umount 
-a always,exit -F path=/usr/bin/ssh-agent -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-ssh 
-a always,exit -F path=/usr/lib/openssh/ssh-keysign -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-ssh 
-a always,exit -F arch=b32 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b32 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid=0 -k perm_mod 
-a always,exit -F arch=b64 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod 
-a always,exit -F arch=b64 -S setxattr,fsetxattr,lsetxattr,removexattr,fremovexattr,lremovexattr -F auid=0 -k perm_mod 
-a always,exit -F arch=b32 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_chng 
-a always,exit -F arch=b64 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_chng 
-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_chng 
-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_chng 
-a always,exit -F arch=b32 -S creat,open,openat,open_by_handle_at,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access 
-a always,exit -F arch=b32 -S creat,open,openat,open_by_handle_at,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access 
-a always,exit -F arch=b64 -S creat,open,openat,open_by_handle_at,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k perm_access 
-a always,exit -F arch=b64 -S creat,open,openat,open_by_handle_at,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k perm_access 
-a always,exit -F path=/usr/bin/sudo -F perm=x -F auid>=1000 -F auid!=4294967295 -k priv_cmd 
-a always,exit -F path=/usr/bin/sudoedit -F perm=x -F auid>=1000 -F auid!=4294967295 -k priv_cmd 
-a always,exit -F path=/usr/bin/chsh -F perm=x -F auid>=1000 -F auid!=4294967295 -k priv_cmd
-a always,exit -F path=/usr/bin/newgrp -F perm=x -F auid>=1000 -F auid!=4294967295 -k priv_cmd 
-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=1000 -F auid!=4294967295 -k perm_chng 
-a always,exit -F path=/sbin/apparmor_parser -F perm=x -F auid>=1000 -F auid!=4294967295 -k perm_chng 
-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=1000 -F auid!=4294967295 -k perm_chng 
-a always,exit -F path=/usr/bin/chacl -F perm=x -F auid>=1000 -F auid!=4294967295 -k perm_chng 
-w /var/log/tallylog -p wa -k logins 
-w /var/log/faillog -p wa -k logins 
-w /var/log/lastlog -p wa -k logins
-a always,exit -F path=/usr/bin/passwd -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-passwd 
-a always,exit -F path=/sbin/unix_update -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-unix-update 
-a always,exit -F path=/usr/bin/gpasswd -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-gpasswd 
-a always,exit -F path=/usr/bin/chage -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-chage
-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-usermod
-a always,exit -F path=/usr/bin/crontab -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-crontab
-a always,exit -F path=/usr/sbin/pam_timestamp_check -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged-pam_timestamp_check 
-a always,exit -F arch=b32 -S init_module,finit_module -F auid>=1000 -F auid!=4294967295 -k module_chng 
-a always,exit -F arch=b64 -S init_module,finit_module -F auid>=1000 -F auid!=4294967295 -k module_chng 
-a always,exit -F arch=b32 -S delete_module -F auid>=1000 -F auid!=4294967295 -k module_chng 
-a always,exit -F arch=b64 -S delete_module -F auid>=1000 -F auid!=4294967295 -k module_chng
-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -F key=execpriv 
-a always,exit -F arch=b64 -S execve -C gid!=egid -F egid=0 -F key=execpriv 
-a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -F key=execpriv 
-a always,exit -F arch=b32 -S execve -C gid!=egid -F egid=0 -F key=execpriv 
-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat,rmdir -F auid>=1000 -F auid!=4294967295 -k delete 
-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat,rmdir -F auid>=1000 -F auid!=4294967295 -k delete 
-w /var/log/wtmp -p wa -k logins 
-w /var/run/wtmp -p wa -k logins 
-w /var/log/btmp -p wa -k logins 
-w /sbin/modprobe -p x -k modules 
-w /bin/kmod -p x -k modules 
-w /usr/sbin/fdisk -p x -k fdisk
-w /etc/passwd -p wa -k usergroup_modification 
-w /etc/group -p wa -k usergroup_modification 
-w /etc/shadow -p wa -k usergroup_modification 
-w /etc/gshadow -p wa -k usergroup_modification 
-w /etc/security/opasswd -p wa -k usergroup_modification 
" > /etc/audit/rules.d/stig.rules

augenrules --load

#4.1.17
echo "-D
-b 8192
--backlog_wait_time 0
-f 1" >> /etc/audit/rules.d/audit.rules

#READD -e 2

modify_config_setting /etc/audit/auditd.conf disk_full_action HALT

#Refreshing auditd so the audits kick in
chmod 0600 /var/log/audit/*
chown root /var/log/audit/*

chown root:root /etc/audit/audit*.{rules,conf} /etc/audit/rules.d/*
chmod -R 0640 /etc/audit/audit*.{rules,conf} /etc/audit/rules.d/*

augenrules --load > /dev/null

systemctl restart auditd

#4.2.1.1
apt install rsyslog -y

#4.2.1.2
systemctl --now enable rsyslog

#4.2.1.3 - technically should be "reload" but doesn't work
systemctl restart rsyslog

#4.2.2.1
echo "ForwardToSyslog=yes" >> /etc/systemd/journald.conf

#4.2.2.2
echo "Compress=yes" >> /etc/systemd/journald.conf

#4.2.2.3
echo "Storage=persistent" >> /etc/systemd/journald.conf