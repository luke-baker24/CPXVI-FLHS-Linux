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
OSNAME=$(lsb_release -a | grep "Distributor ID" | awk -F ":\t" "{ print $2}")
VERSION=$(lsb_release -a | grep "Codename" | awk -F ":\t" "{ print $2}")

#Detects Jammy Ubuntu
if [ "$OSNAME" == "Ubuntu" ] && [ "$VERSION" == "jammy" ]; then
    echo "Running on version Jammy Jellyfish"

#Detects Focal Ubuntu
elif [ "$OSNAME" == "Ubuntu" ] && [ $VERSION == "focal" ]; then
        echo "Running on version Focal Fossa"

#Detects Debian
elif [ "$OSNAME" == "Debian" ]; then
    VERSION="debian"
    echo "Running on Debian 11"

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

#Verify whiptail is installed on the system
if [[ $(which whiptail) ]]; then
    echo "Whiptail installed"
else
    echo "Whiptail is not installed."

    apt install whiptail
fi

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

rm -rf logs

mkdir logs

while true; do
    CHOICE=$(
        whiptail --title "What scans do you want to run?" --menu "" 18 50 10 \
            "1)" "User scan." \
            "2)" "Package/snap scan." \
            "X)" "Exit." 3>&2 2>&1 1>&3	
    )

    case $CHOICE in
        "1)")
            ./subscripts/scans/users.sh "$(pwd)/baselines/$VERSION"
        ;;
        "2)")
            ./subscripts/scans/apt.sh "$(pwd)/baselines/$VERSION"
        ;;
        "X)")
            break
        ;;
    esac
done

while true; do
    CHOICE=$(
        whiptail --title "What policies do you want to enforce?" --menu "" 18 50 10 \
            "1)" "Apt security." \
            "2)" "Firefox settings." \
            "3)" "Configure UFW." \
            "4)" "Secure kernel sysctl settings." \
            "X)" "Exit." 3>&2 2>&1 1>&3	
    )

    case $CHOICE in
        "1)")
            ./subscripts/policies/apt.sh
        ;;
        "2)")
            ./subscripts/policies/firefox.sh
        ;;
        "3)")
            ./subscripts/policies/firewall.sh
        ;;
        "4)")
            ./subscripts/policies/kernel.sh
        ;;
        "X)")
            break
        ;;
    esac
done