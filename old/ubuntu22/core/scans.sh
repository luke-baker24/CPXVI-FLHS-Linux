cd scans

while true
do
    CHOICE=$(
    whiptail --title "What scans do you want to run?" --menu "" 18 50 10 \
        "1)" "Software scan."   \
        "2)" "Aide scan."  \
        "3)" "Malware scan." \
        "4)" "Check Lynis compliance." \
        "5)" "Run CIS audits." \
        "X)" "Back." 3>&2 2>&1 1>&3	
    )

    case $CHOICE in
        "1)")
            ./appscan.sh      $1
        ;;
        "2)")   
            ./aidescan.sh     $1
        ;;
        "3)")   
            ./malwarescan.sh  $1
        ;;
        "4)")   
            ./lynisscan.sh    $1
        ;;
        "5)")   
            ./cisscans.sh     $1
        ;;
        "X)")
            cd ..
            break
        ;;
    esac
done