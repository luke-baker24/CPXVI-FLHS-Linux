ChangeConfigSetting()
{
    if grep -P -q "^$1\s+\S+" /etc/vsftpd.conf; then
        sed -r -i "s|^"$1"\s+\S+|"$1"="$2"|" /etc/vsftpd.conf
    else
        echo "$1=$2" >> /etc/vsftpd.conf
    fi
}

ChangeConfigSetting allow_anon_ssl yes
ChangeConfigSetting anon_mkdir_write_enable NO
ChangeConfigSetting anon_other_write_enable NO
ChangeConfigSetting anon_upload_enable NO
ChangeConfigSetting anon_world_readable_only YES
ChangeConfigSetting anonymous_enable NO
ChangeConfigSetting ascii_download_enable YES
ChangeConfigSetting ascii_upload_enable YES
ChangeConfigSetting async_abor_enable NO
ChangeConfigSetting background YES
ChangeConfigSetting chmod_enable NO
ChangeConfigSetting chown_uploads YES
ChangeConfigSetting chroot_list_enable NO
ChangeConfigSetting chroot_local_user NO
ChangeConfigSetting connect_from_port_20 YES
ChangeConfigSetting debug_ssl NO
ChangeConfigSetting delete_failed_uploads YES
ChangeConfigSetting deny_email_enable NO
ChangeConfigSetting dirlist_enable YES
ChangeConfigSetting dirmessage_enable NO
ChangeConfigSetting download_enable NO
ChangeConfigSetting dual_log_enable NO
ChangeConfigSetting force_dot_files YES
ChangeConfigSetting force_anon_data_ssl YES
ChangeConfigSetting force_anon_logins_ssl YES
ChangeConfigSetting force_local_data_ssl YES
ChangeConfigSetting force_local_logins_ssl YES
ChangeConfigSetting guest_enable NO
ChangeConfigSetting hide_ids NO
ChangeConfigSetting implicit_ssl YES
ChangeConfigSetting listen NO
ChangeConfigSetting listen_ipv6 NO
ChangeConfigSetting local_enable NO
ChangeConfigSetting lock_upload_files NO
ChangeConfigSetting log_ftp_protocol YES
ChangeConfigSetting ls_recurse_enable NO
ChangeConfigSetting mdtm_write YES
ChangeConfigSetting no_anon_password NO
ChangeConfigSetting no_log_lock NO
ChangeConfigSetting one_process_model NO
ChangeConfigSetting passwd_chroot_enable NO
ChangeConfigSetting pasv_addr_resolve NO
ChangeConfigSetting pasv_addr_resolve YES
ChangeConfigSetting pasv_promiscuous NO
ChangeConfigSetting port_enable YES
ChangeConfigSetting port_promiscuous NO
ChangeConfigSetting require_cert YES
ChangeConfigSetting require_ssl_reuse YES
ChangeConfigSetting run_as_launching_user NO
ChangeConfigSetting secure_email_list_enable NO
ChangeConfigSetting session_support NO
ChangeConfigSetting setproctitle_enable NO
ChangeConfigSetting ssl_enable NO
ChangeConfigSetting ssl_request_cert YES
ChangeConfigSetting strict_ssl_read_eof YES
ChangeConfigSetting strict_ssl_write_shutdown YES
ChangeConfigSetting syslog_enable NO
ChangeConfigSetting tcp_wrappers NO
ChangeConfigSetting text_userdb_names NO
ChangeConfigSetting tilde_user_enable NO
ChangeConfigSetting use_localtime NO
ChangeConfigSetting use_sendfile YES
ChangeConfigSetting userlist_enable NO
ChangeConfigSetting validate_cert YES
ChangeConfigSetting virtual_use_local_privs NO
ChangeConfigSetting write_enable NO
ChangeConfigSetting xferlog_enable YES
ChangeConfigSetting xferlog_std_format NO
ChangeConfigSetting accept_timeout NO
ChangeConfigSetting anon_max_rate 8192
ChangeConfigSetting anon_umask 077
ChangeConfigSetting chown_upload_mode 0600
ChangeConfigSetting connect_timeout 60
ChangeConfigSetting data_connection_timeout 60
ChangeConfigSetting delay_failed_login 1
ChangeConfigSetting delay_successful_login 1
ChangeConfigSetting file_open_mode 0666
ChangeConfigSetting ftp_data_port 20
ChangeConfigSetting idle_session_timeout 180
ChangeConfigSetting listen_port 21
ChangeConfigSetting local_max_rate 8192
ChangeConfigSetting local_umask 077
ChangeConfigSetting max_clients 3
ChangeConfigSetting max_login_fails 3
ChangeConfigSetting max_per_ip 1
ChangeConfigSetting pasv_max_port 0
ChangeConfigSetting pasv_min_port 0
ChangeConfigSetting trans_chunk_size 8192
ChangeConfigSetting anon_root /

ChangeConfigSetting banner_file /etc/vsftpd/my_banner
echo "Authorized access only" > /etc/vsftpd/my_banner

ChangeConfigSetting chown_username root
ChangeConfigSetting ftp_username ftp
ChangeConfigSetting local_root /
ChangeConfigSetting message_file .message
ChangeConfigSetting pam_service_name vsftpd
ChangeConfigSetting rsa_cert_file /usr/share/ssl/certs/vsftpd.pem
ChangeConfigSetting secure_chroot_dir /var/run/vsftpd/empty
ChangeConfigSetting ssl_ciphers DES-CBC3-SHA
ChangeConfigSetting vsftpd_log_file /var/log/vsftpd.log
ChangeConfigSetting xferlog_file /var/log/xferlog