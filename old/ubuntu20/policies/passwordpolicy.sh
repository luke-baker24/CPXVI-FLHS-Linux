sudo apt install login -y


#Check that root is the only one with uid 0

cd ..

./passwords.sh

cd policies

modify_login_setting()
{
    cat /etc/login.defs | grep -vP "^$1" > /etc/login.defs
    echo "$1 $2" >> /etc/login.defs
}

modify_login_setting PASS_MAX_DAYS 90 #5.1.1.2
modify_login_setting PASS_MIN_DAYS 7  #5.5.1.1
modify_login_setting PASS_WARN_AGE 14 #5.5.1.3

modify_login_setting LOG_UNKFAIL_ENAB no

modify_login_setting FAILLOG_ENAB no

modify_login_setting SYSLOG_SG_ENAB yes
modify_login_setting SYSLOG_SU_ENAB yes

modify_login_setting ENCRYPT_METHOD SHA512

modify_login_setting UMASK 027

modify_login_setting LOGIN_RETRIES 3
modify_login_setting LOGIN_TIMEOUT 60

modify_login_setting USERDEL_CMD /usr/sbin/deluser



apt remove libpam-cracklib -y
apt install libpam-pwquality -y

#CIS 5.4 is all PAM here
echo "account required pam_tally2.so
account [success=1 new_authtok_reqd=done default=ignore] pam_unix.so 
account	requisite pam_deny.so
account	required pam_permit.so" > /etc/pam.d/common-account

echo "auth required pam_env.so
auth required pam_faildelay.so delay=4000000
auth required pam_faillock.so preauth silent audit deny=3 unlock_time=1800 even_deny_root
auth [success=1 default=ignore] pam_unix.so nullok
auth requisite pam_deny.so
auth required pam_permit.so" > /etc/pam.d/common-auth

echo "password requisite pam_pwquality.so retry=3
password required pam_pwhistory.so remember=5
password [success=1 default=ignore] pam_unix.so nullok obscure minlen=8 sha512 
password requisite pam_deny.so
password required pam_permit.so" > /etc/pam.d/common-password


echo "audit
silent
deny = 3
fail_interval = 1800
unlock_time = 0
even_deny_root
root_unlock_time = 1800" > /etc/security/faillock.conf

#5.4.1
echo "difok=8
minlen=15
dcredit=-1
ucredit=-1
lcredit=-1
ocredit=-1
minclass=4
maxclassrepeat=3
gecoscheck=1
dictcheck=1
usercheck=1
enforcing = 1
retry=3
enforce_for_root" > /etc/security/pwquality.conf

echo "session required pam_lastlog.so showfailed
$(cat /etc/pam.d/login)" | tee /etc/pam.d/login

useradd -D -f 30 #5.5.1.4

usermod -g 0 root #5.5.3

#6.2.1
sed -e 's/^\([a-zA-Z0-9_]*\):[^:]*:/\1:x:/' -i /etc/passwd
