apt install login -y

#Check that root is the only one with uid 0

modify_login_setting()
{
    if grep -q -P "^$1" /etc/login.defs
    then
    	cat /etc/login.defs | grep -v -P "^$1" | tee /etc/login.defs
    else
    	echo "Hello World"
    fi

    echo "$1 $2" | tee -a /etc/login.defs
}

cp /etc/login.defs ./backuplogin.defs

cat /etc/login.defs | grep -v "^#" | tee /etc/login.defs

#5.1.1.2
modify_login_setting PASS_MAX_DAYS 60
#5.5.1.1
modify_login_setting PASS_MIN_DAYS 7  
#5.5.1.3
modify_login_setting PASS_WARN_AGE 14

modify_login_setting LOG_UNKFAIL_ENAB no

modify_login_setting FAILLOG_ENAB no

modify_login_setting SYSLOG_SG_ENAB yes
modify_login_setting SYSLOG_SU_ENAB yes

modify_login_setting ENCRYPT_METHOD SHA512

modify_login_setting UMASK 077

modify_login_setting LOGIN_RETRIES 3
modify_login_setting LOGIN_TIMEOUT 60

modify_login_setting USERDEL_CMD /usr/sbin/deluser

