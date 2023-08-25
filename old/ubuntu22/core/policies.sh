cd policies

while true
do
    CHOICE=$(
    whiptail --title "What policies do you want to run?" --menu "" 24 50 16 \
        "1)"  "Account policy."   \
        "2)"  "Audit policy."  \
        "3)"  "Harden file permissions." \
        "4)"  "Harden filesystems." \
        "5)"  "Harden Firefox." \
        "6)"  "Harden GNOME (the display manager)." \
        "7)"  "Harden Grub (the bootloader)." \
        "8)"  "Harden the kernel." \
        "9)"  "Password policy." \
        "10)" "Harden PKCS11." \
        "11)" "Harden sudo." \
        "12)" "Configure automatic updates." \
        "13)" "Harden the firewall." \
        "14)" "User security." \
        "15)" "Services security." \
        "M)" "Miscellaneous hardening." \
        "X)" "Back." 3>&2 2>&1 1>&3	
    )

    case $CHOICE in
        "1)")
            ./accountpolicy.sh &> /dev/null
        ;;
        "2)")   
            ./audits.sh   &> /dev/null
        ;;
        "3)")   
            ./fileperms.sh   &> /dev/null
        ;;
        "4)")   
            ./filesystems.sh   &> /dev/null
        ;;
        "5)")   
            ./firefox.sh     $1  &> /dev/null
        ;;
        "6)")   
            ./gnome.sh     &> /dev/null
        ;;
        "7)")   
            ./grub.sh     &> /dev/null
        ;;
        "8)")   
            ./kernel.sh     &> /dev/null
        ;;
        "9)")   
            ./passwordpolicy.sh     &> /dev/null
        ;;
        "10)")   
            ./pkcs11.sh     &> /dev/null
        ;;
        "11)")   
            ./securesudo.sh     &> /dev/null
        ;;
        "12)")   
            ./updatepolicy.sh     &> /dev/null
        ;;
        "13)")   
            ./firewall.sh     &> /dev/null
        ;;
        "14)")   
            ./users.sh     &> /dev/null
        ;;
        "15)")   
            ./sysservices.sh     &> /dev/null
        ;;
        "M)")   
            ./misc.sh     &> /dev/null
        ;;
        "X)")
            cd ..
            break
        ;;
    esac
done