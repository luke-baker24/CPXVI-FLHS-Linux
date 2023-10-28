#Apt package scan

RED='\033[0;31m' #Red color code
NC='\033[0m' #No color code

directory=$1

output_log () {
    classification="$1"
    message="$2"
    
    echo -e "[ ${RED}$classification${NC} ] $message"
    echo "[ $classification ] $message" >> $directory/../../logs/output.log
}

rm -rf temp

mkdir temp

apt list --installed 2>/dev/null | tail -n +2 | cut -d "/" -f 1 > temp/installedpackages.txt

for new_package in $(grep -xvf $directory/packages.txt temp/installedpackages.txt)
do
    if ! [[ $(dpkg -s $new_package | grep "^Source") ]]
    then
        output_log "PKG" "$new_package is an unauthorized parent package"
    fi
done


#Snap scan
snap list | cut -d $'\t' -f 1 | cut -d " " -f 1 | tail +2 > temp/snaplist.txt

for new_package in $(grep -xvf $directory/snaps.txt temp/snaplist.txt)
do
    output_log "SNP" "$new_package is an unauthorized snap"
done

#Clear the temp directory
rm -r temp