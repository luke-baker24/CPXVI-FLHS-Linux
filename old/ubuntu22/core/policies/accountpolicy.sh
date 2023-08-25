#!/bin/bash

apt install login -y

modify_login_setting()
{
    if grep -P -q "^$1\s+\S+" /etc/login.defs; then
        sed -r -i "s|^"$1"\s+\S+|"$1" "$2"|" /etc/login.defs
    else
        echo "$1 $2" >> /etc/login.defs
    fi
}

modify_login_setting PASS_MAX_DAYS 30
modify_login_setting PASS_MIN_DAYS 7  
modify_login_setting PASS_WARN_AGE 14
modify_login_setting UMASK 027
modify_login_setting LOGIN_RETRIES 3
modify_login_setting LOGIN_TIMEOUT 60
modify_login_setting USERDEL_CMD /usr/sbin/deluser
modify_login_setting MAIL_DIR /var/Mail
modify_login_setting FAILLOG_ENAB yes
modify_login_setting LOG_UNKFAIL_ENAB no
modify_login_setting LOG_OK_LOGINS yes
modify_login_setting SULOG_FILE /var/log/sulog
modify_login_setting FTMP_FILE /var/log/btmp
modify_login_setting SU_NAME su
modify_login_setting HUSHLOGIN_FILE .hushlogin
modify_login_setting ENV_SUPATH PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
modify_login_setting ENV_PATH PATH=/usr/local/bin:/usr/bin:/bin
modify_login_setting TTYGROUP tty
modify_login_setting TTYPERM 0600
modify_login_setting ERASECHAR 0177
modify_login_setting KILLCHAR 025
modify_login_setting UID_MIN 1000
modify_login_setting UID_MAX 60000
modify_login_setting GID_MIN 1000
modify_login_setting GID_MAX 60000
modify_login_setting CHFN_RESTRICT rwh
modify_login_setting DEFAULT_HOME no
modify_login_setting USERGROUPS_ENAB yes