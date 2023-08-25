ChangeConfigSetting()
{
    cat sshd_config | egrep -v "^$1\s*" | tee sshd_config
    echo "$1 $2" | tee -a sshd_config
}

cp /etc/ssh/sshd_config sshd_config

ChangeConfigSetting AcceptEnv no
ChangeConfigSetting AddressFamily inet
ChangeConfigSetting AllowAgentForwarding no
ChangeConfigSetting AllowTcpForwarding no

ChangeConfigSetting Banner /etc/ssh/my_banner
echo "Authorized access only" > /etc/ssh/my_banner

#Come back to /etc/systemd/ config files

ChangeConfigSetting KbdInteractiveAuthetication yes
ChangeConfigSetting Ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
ChangeConfigSetting ClientAliveCountMax 1 #unsure
ChangeConfigSetting ClientAliveInterval 180
ChangeConfigSetting Compression no
ChangeConfigSetting GatewayPorts no
ChangeConfigSetting GSSAPIAuthentication no
ChangeConfigSetting HostbasedAuthentication no
ChangeConfigSetting IgnoreRhosts yes
ChangeConfigSetting HostKey 
ChangeConfigSetting IgnoreUserKnownHosts yes
ChangeConfigSetting KerberosAuthentication no
ChangeConfigSetting LoginGraceTime 30 
ChangeConfigSetting LogLevel VERBOSE
ChangeConfigSetting AllowStreamLocalForwarding no
ChangeConfigSetting AuthenticationMethods publickey,password

#Check all of this manually
#ChangeConfigSetting AuthorizedKeysCommand 
#ChangeConfigSetting AuthorizedKeysCommandUser 
#ChangeConfigSetting AuthorizedKeysFile ".ssh/authorized_keys .ssh/authorized_keys2" 
#ChangeConfigSetting AuthorizedPrincipalsCommand 
#ChangeConfigSetting AuthorizedPrincipalsFile 
#ChangeConfigSetting AuthorizedPrincipalsCommandUser
ChangeConfigSetting CASignatureAlgorithms rsa-sha2-512,rsa-sha2-256
ChangeConfigSetting DisableForwarding yes
ChangeConfigSetting ExposeAuthInfo no
ChangeConfigSetting FingerprintHash sha256
ChangeConfigSetting ForceCommand none
ChangeConfigSetting KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group16-sha512,diffie-hellman-group15-sha512,diffie-hellman-group14-sha526,diffie-hellman-group-exchage-sha256
ChangeConfigSetting LogVerbose 
ChangeConfigSetting MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com
ChangeConfigSetting Match 
ChangeConfigSetting MaxAuthTries 3
ChangeConfigSetting MaxSessions 5
ChangeConfigSetting MaxStartups 10:30:100
ChangeConfigSetting PasswordAuthentication yes
ChangeConfigSetting PermitEmptyPasswords no

#check
#ChangeConfigSetting PermitListen 
#check
#ChangeConfigSetting PermitOpen
#
ChangeConfigSetting PermitRootLogin no
ChangeConfigSetting PermitTTY no
ChangeConfigSetting PermitTunnel no
ChangeConfigSetting PermitUserEnvironment no
ChangeConfigSetting PermitUserRc no
ChangeConfigSetting PerSourceMaxStartups 1
ChangeConfigSetting PerSourceNetBlockSize 32:128
ChangeConfigSetting PidFile /var/run/sshd.pid
ChangeConfigSetting Port 2222
ChangeConfigSetting PrintLastLog yes
ChangeConfigSetting PrintMotd yes
ChangeConfigSetting PubkeyAcceptedAlgorithms ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp512,rsa-sha2-512,rsa-sha2-256,ssh-rsa-sha256@ssh.com
ChangeConfigSetting PubkeyAuthOptions verify-required
ChangeConfigSetting PubkeyAuthentication yes
ChangeConfigSetting RequiredRSASize 4096
ChangeConfigSetting RevokedKeys  
ChangeConfigSetting SetEnv  
ChangeConfigSetting StreamLocalBindUnlink no
ChangeConfigSetting StreamLocalBindMask 0177
ChangeConfigSetting StrictModes yes
ChangeConfigSetting Subsystem 
ChangeConfigSetting SyslogFacility AUTH
ChangeConfigSetting TCPKeepAlive no
ChangeConfigSetting TrustedUserCAKeys 
ChangeConfigSetting UseDNS yes
ChangeConfigSetting UsePAM no
ChangeConfigSetting VersionAddendum none
ChangeConfigSetting X11Forwarding no

if [ $(wc -l < sshd_config) -ge 40 ]
then
    cp sshd_config /etc/ssh/sshd_config
    rm sshd_config

    exit
else
    ./ssh.sh
fi
