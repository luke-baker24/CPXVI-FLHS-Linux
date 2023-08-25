# TODO change repo file configs?? mainly certain gpg checks and move newconfig to its own file, setup DNSSEC http://miroslav.suchy.cz/blog/archives/2021/02/11/verify_package_gpg_signature_using_dnssec/index.html
# COMB THROUGH man dnf.conf

dnfconf=/etc/dnf/dnf.conf
# Import fedora 36 GPG key
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-36-primary

<< old
# Turn on GPG check (ensures the software has not been tampered with and that it has been provided by a trusted vendor.)
if grep -q gpgcheck=False $dnfconf; then
  sed -i "s/gpgcheck=False/gpgcheck=True/g" $dnfconf
  echo "gpgcheck was set to false" >> log.txt
fi
if ! grep -q localpkg_gpgcheck $dnfconf; then
  echo "localpkg_gpgcheck=True" >> $dnfconf
  echo "localpkg_gpgcheck was not set" >> log.txt
fi
old

# Make sure gpg check is enabled on repo files
sed -i 's/gpgcheck\s*=.*/gpgcheck=1/g' /etc/yum.repos.d/*

cat $dnfconf
read -p "Override current dnf config? [Y/N]: " output
if [[ $output = "Y" || $output = "y" ]]; then
  dnf install python3-unbound -y
  cat >/etc/dnf/dnf.conf << newconfig 
[main]
gpgcheck=True
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
localpkg_gpgcheck=True
assumeyes=False
autocheck_running_kernel=True
check_config_file_age=True
defaultyes=False
debuglevel=2
group_package_types=default, mandatory
keepcache=False
obsoletes=True
repo_gpgcheck=True
sslverify=True
gpgkey_dns_verification=True
newconfig
  echo "Installed python3-unbound for gpgkey_dns_verification" >> log.txt
  echo "Overwrote dnf config" >> log.txt
fi
