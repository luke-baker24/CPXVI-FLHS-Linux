#!/bin/bash

################################################################################################
# Prerequisite stuff                                                                           #
################################################################################################

#Making sure script was run with root
if [ $(id -u) == "0" ]; then
    echo "Running with root permissions"

#Not run with root - root is necessary for script so exit
else
    echo "Please run the script with root permissions."
    exit
fi

#Getting ubuntu version
OSNAME=$(lsb_release -a | grep "Distributor ID" | cut -d $'\t' -f 2)
VERSION=$(lsb_release -a | grep "Codename" | cut -d $'\t' -f 2)

#Detects Jammy Ubuntu
if [ "$OSNAME" == "Ubuntu" ] && [ "$VERSION" == "jammy" ]; then
    echo "Running on version Jammy Jellyfish"

#Detects Focal Ubuntu
elif [ "$OSNAME" == "Ubuntu" ] && [ $VERSION == "focal" ]; then
        echo "Running on version Focal Fossa"

#Detects Bionic Ubuntu
elif [ "$OSNAME" == "Ubuntu" ] && [ $VERSION == "bionic" ]; then
        echo "Running on version Bionic Beaver"

#Detects Debian
elif [ "$OSNAME" == "Debian" ]; then
    VERSION="debian"
    echo "Running on Debian 11 / Bullseye"

#Version not detected - file broken
else
    echo "Version not found - was lsb_release tampered with or inaccessible?"

    #Check if the user says yes or no
    echo "Input version manually? (y/n)" 
    read yninput

    #User will manually input version number
    if [ $yninput == "y" ]; then
        echo "Enter version codename (ex. jammy): "
        read VERSION
         
    #User does not manually input version number - necessary for script so exit
    else
        echo "Exiting."
        exit
    fi
fi

################################################################################################
# Dependency installation                                                                      #
################################################################################################

#Verify whiptail is installed on the system
if [[ $(which whiptail) ]]; then
    echo "Whiptail installed"
else
    echo "Whiptail is not installed."

    apt install whiptail
fi

#Changing the colors cause everything's gotta be pretty
export NEWT_COLORS='
window=blue,white
border=black,white
textbox=black,white
button=black,white
'

whiptail --msgbox \
'
              Welcome To
   ______ _      _   _  _____  _   _ 
   |  ___| |    | | | |/  ___|| | | |
   | |_  | |    | | | |\ `--. | |_| |
   |  _| | |    | | | | `--. \|  _  |
   | |_  | |____| |_| |/\__/ /| | | |
   \_(_) \_____(_)___(_)____(_)_| |_/

Faith Lutheran Ubuntu Security Helper (2.0)' 16 42

################################################################################################
# Scans loop                                                                                   #
################################################################################################

mkdir logs

touch logs/output.log

chmod 666 logs/output.log

while true; do
    CHOICE=$(
        whiptail --title "What scans do you want to run?" --menu "" 18 50 10 \
            "1)" "Scans." \
            "2)" "Policies." \
            "3)" "Critical service configurations." \
            "4)" "Browser configurations." \
            "X)" "Exit." 3>&2 2>&1 1>&3	
    )

    case $CHOICE in
        "1)")
            while true; do
                SUBCHOICE=$(
                    whiptail --title "What scans do you want to run?" --menu "" 18 50 10 \
                        "1)" "User scan." \
                        "2)" "Package/snap scan." \
                        "3)" "Home directories scan." \
                        "4)" "/usr files scan." \
                        "X)" "Exit." 3>&2 2>&1 1>&3	
                )

                case $SUBCHOICE in
                    "1)")
                        ./subscripts/scans/users.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "2)")
                        ./subscripts/scans/packages.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "3)")
                        ./subscripts/scans/homedirs.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "4)")
                        ./subscripts/scans/files.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "X)")
                        break
                    ;;
                esac
            done
        ;;
        "2)")
            while true; do
                CHOICE=$(
                    whiptail --title "What policies do you want to enforce?" --menu "" 18 50 10 \
                        "1)" "Apt security." \
                        "2)" "Firefox settings." \
                        "3)" "Configure UFW." \
                        "4)" "Secure kernel sysctl settings." \
                        "5)" "File permissions." \
                        "X)" "Exit." 3>&2 2>&1 1>&3	
                )

                case $CHOICE in
                    "1)")
                        ./subscripts/policies/apt.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "2)")
                        ./subscripts/policies/firefox.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "3)")
                        ./subscripts/policies/firewall.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "4)")
                        ./subscripts/policies/kernel.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "5)")
                        ./subscripts/policies/fileperms.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "X)")
                        break
                    ;;
                esac
            done
        ;;
        "3)")
            while true; do
                CHOICE=$(
                    whiptail --title "What configs do you want to diff?" --menu "" 18 50 10 \
                        "1)" "sshd" \
                        "2)" "vsftpd" \
                        "3)" "apache" \
                        "4)" "openvpn" \
                        "5)" "nginx" \
                        "6)" "postfix" \
                        "7)" "bind9" \
                        "8)" "mysql" \
                        "9)" "samba" \
                        "10)" "php" \
                        "X)" "Exit." 3>&2 2>&1 1>&3	
                )

                #case $CHOICE in
                #    "1)")
                #        #pass
                #    ;;
                #    "X)")
                #        break
                #    ;;
                #esac
            done
        ;;
        "4)")
            while true; do
                CHOICE=$(
                    whiptail --title "What browsers do you want to harden?" --menu "" 18 50 10 \
                        "1)" "Firefox" \
                        "2)" "Chromium" \
                        "X)" "Exit." 3>&2 2>&1 1>&3	
                )

                case $CHOICE in
                    "1)")
                        ./subscripts/policies/firefox.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "2)")
                        ./subscripts/policies/chromium.sh "$(pwd)/baselines/$VERSION"
                    ;;
                    "X)")
                        break
                    ;;
                esac
            done
        ;;
        "X)")
            break
        ;;
    esac
done
