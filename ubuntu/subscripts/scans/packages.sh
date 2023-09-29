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


whitelist=""

rm -rf temp

mkdir temp

while read package; do
    if [[ $package ]] && [[ $(apt list --installed 2>/dev/null | tail -n +2 | grep $package) ]]; then
        #this apt cache command sucks 
        whitelist="$whitelist:$(apt-cache depends --no-suggests --no-breaks --no-conflicts --no-replaces --recurse $package | grep -v '<' | rev | cut -d ' ' -f -1 | rev | cut -d ':' -f 1 | sort -u | sed 's/\$/\|/')"
    fi
done < $directory/metapackages.txt

echo $whitelist | tr " " "\n" > temp/whitelist.txt

apt list --installed 2>/dev/null | tail -n +2 | cut -d "/" -f 1 > temp/installedpackages.txt

for new_package in $(grep -v -x -f temp/whitelist.txt temp/installedpackages.txt)
do
    if [[ $(dpkg -s $new_package | grep Source) ]]
    then
        echo "Cool" > /dev/null
    else
        output_log "PKG" "$new_package is an unauthorized parent package"
    fi
done


#Snap scan
snap list | cut -d $'\t' -f 1 | cut -d " " -f 1 | tail +2 > temp/snaplist.txt

for new_package in $(grep -v -x -f $directory/snaps.txt temp/snaplist.txt)
do
    output_log "PKG" "$new_package is an unauthorized snap"
done

#Clear the temp directory
rm -r temp





#File directories








### Binaries & Libraries :

#/usr: contains user utilities and applications, and replicates the root directory structure
    #/bin: stores important command binaries (no subdirectories)
        #Most files initialized with major upgrades or installs
        #Installedpplications will get command files in bin
    #/sbin: contains important admin commands, should only be modified by root
        #Shouldn't really be anything super recent in there.
    #/lib*: very important dynamic libraries & kernel modules
        #RESEARCH HEAVILY
    #games:
        #Should be easy to baseline. Shouldn't have any more files
    #src:
        #RESEARCH HEAVILY
    #share:
        #RESEARCH HEAVILY
    #include:
        #RESEARCH HEAVILY
    #local:
        #Seems pretty empty normally. Should be easy to baseline



### Etc :

#/etc: system-global configuration files
    #Holy cow so much here
    #RESEARCH
    #RESEARCH
    #RESEARCH



### Boot :

#/boot: files needed to start the system
    #RESEARCH HEAVILY



### Home dirs: 

#/home: user home directories
    #Scan, but should be easier to scan - look for any files not in the standard home dir
#/root: root's home directory



### For Services only :

#/srv: contains directories for services
    #Just see if anything's there that shouldn't be - should be entirely empty
    #Unless a crit service uses it
#/opt: additional software for the system



### Devices (should be blank) :

#/media: mount point for external devices
    #Just see if anything's there that shouldn't be - should be essentially empty
#/mnt: temporary mount points, like network filesystems
    #Just see if anything's there that shouldn't be - should be entirely empty



### VFS's (cannot baseline) :

#/tmp: temporary files used by applications
#/run: temporary filesystem for booting
#/proc: running processes
#/dev: device files
#/sys: virtual filesystem for the kernel's view