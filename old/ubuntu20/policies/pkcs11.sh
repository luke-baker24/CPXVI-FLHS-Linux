apt install libpam-pkcs11
apt install opensc-pkcs11

touch /etc/pam_pkcs11/pam_pkcs11.conf

echo "use_mappers=pwent
cert_policy=ca,signature,oscp_on,crl_auto;" > /etc/pam_pkcs11/pam_pkcs11.conf
