cat /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="audit=1 /' | tee /etc/default/grub

cat /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="ipv6.disable=1 /' | tee /etc/default/grub

cat /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="apparmor=1 /' | tee /etc/default/grub

cat /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="security=apparmor /' | tee /etc/default/grub

#1.4.1
sed -ri 's/chmod\s+[0-7][0-7][0-7]\s+\$\{grub_cfg\}\.new/chmod 400 ${grub_cfg}.new/' /usr/sbin/grub-mkconfig
sed -ri 's/ && ! grep "\^password" \$\{grub_cfg\}.new >\/dev\/null//' /usr/sbin/grub-mkconfig

update-grub