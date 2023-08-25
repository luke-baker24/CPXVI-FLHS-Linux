packagesscan()
{
    while read app
    do
        if grep -q -wi "$app" ../baselines/packagebaseline.txt; then
            echo "O $app" &> /dev/null
        else
            echo "PACKAGE FINDING: $app"
        fi
    done < <(apt list --installed | cut -f 1 -d "/" | tail -n +2)
}

servicesscan()
{
    while read service
    do
        if grep -q -wi "$service" ../baselines/servicebaseline.txt; then
            echo "O $service" &> /dev/null
        else
            echo "SERVICE FINDING: $service"
        fi
    done < <(sudo systemctl list-units | sed 's/  */ /g' | sed 's/ //' | grep "." | head -n -5)
}

echo "
=====================================================================
Running a application (package/service) scan
=====================================================================
" >> $1/fluff.log

echo "[SCAN] Package scan" >> $1/flush.log
packagesscan >> $1/fluff.log

echo "[SCAN] Service scan" >> $1/flush.log
servicesscan >> $1/fluff.log
