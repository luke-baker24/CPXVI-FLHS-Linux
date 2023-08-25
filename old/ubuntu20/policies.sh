#Master script for enforcing local/account policies.

cd ./policies

./accountpolicy.sh
./audits.sh
./fileperms.sh
./firefox.sh
./firewall.sh
./gnome.sh
./grub.sh
./kernel.sh
./misc.sh
./updatepolicy.sh
./pkcs11.sh

./securesudo.sh
#./passwordpolicy.sh

./filesystems.sh

cd ..

reboot
