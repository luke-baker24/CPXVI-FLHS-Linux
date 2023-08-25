# TODO: Whiptail gui that asks what services so it opens the port on the firewall
# Install firewall (if its not installed already)
dnf install firewalld nftables -y

# Remove iptables
dnf remove iptables-services -y

# Start firewall
systemctl unmask firewalld
systemctl enable firewalld
systemctl start firewalld

# Mask nftables
systemctl --now mask nftables

# Set zone to public (may have to change)
# firewall-cmd --set-default-zone=block
