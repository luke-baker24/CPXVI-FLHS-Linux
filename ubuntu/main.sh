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
VERSION=$(cat /etc/os-release | grep -x -E 'VERSION_ID=".*"' | cut -d '"' -f 2)

#Detects Jammy
if [ $VERSION == "22.04" ]; then
    echo "Running on version Jammy Jellyfish"

#Detects Focal
elif [ $VERSION == "20.04" ]; then
    echo "Running on version Focal Fossa"

#Version not detected - file broken
else
    echo "Version not found - was /etc/os-release tampered with or inaccessible?"

    #Check if the user says yes or no
    echo "Input version manually? (y/n)" 
    read yninput

    #User will manually input version number
    if [ $yninput == "y" ]; then
        echo "Enter version number (ex. 20.04): "
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


################################################################################################
# Assigning variable values                                                                    #
################################################################################################

#Get the path to use for baselining the system
BASELINES="$(pwd)/baselines/$VERSION"

################################################################################################
# Primary loop                                                                                 #
################################################################################################

while true
do
    CHOICE=$(
        whiptail --title "What scans do you want to run?" --menu "" 18 50 10 \
            "1)" "User scan."                                                \
            "X)" "Exit." 3>&2 2>&1 1>&3	
    )

    case $CHOICE in
        "1)")
            ./subscripts/users.sh
        ;;
        "X)")
            break
        ;;
    esac
done

exit