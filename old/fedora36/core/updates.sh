# TODO Finish auto updates: 

echo "
=====================================================================
Running updates
=====================================================================
" >> $1/fluff.log

ls -a /etc/yum.repos.d
read -p "Do repos look good?" output

# Remove all repos
rm -rf /etc/yum.repos.d/
echo "[PROGRESS] Removed repos." >> $1/fluff.log

# Add repos
### CHECK REPO FILES BEFORE RUNNING!
cp -r repos /etc/yum.repos.d
repoDir="/etc/yum.repos.d"

# Enable repos
echo "Enabling repos..."
find $repoDir -type f | xargs dnf config-manager --add-repo 
find $repoDir -type f | xargs basename -s ".repo" | xargs dnf config-manager --set-enabled
echo "[PROGRESS] Added and enabled new repos." >> $1/fluff.log

# Auto Updates
dnf install dnf-automatic
cp baselines/automatic.conf /etc/dnf/automatic.conf
systemctl enable --now dnf-automatic.timer
echo "[PROGRESS] Auto update enabled." >> $1/fluff.log

# Install Fedora 36 GPG Key
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-36-primary
echo "[PROGRESS] Installed Fedora GPG Key." >> $1/fluff.log

# Overwrote dnf.conf
cp baselines/dnf.conf /etc/dnf/dnf.conf
echo "[PROGRESS] Overwrote dnf.conf."

# Run Updates
dnf check-upgrade
dnf upgrade -y
echo "[PROGRESS] Updating packages." >> $1/fluff.log
