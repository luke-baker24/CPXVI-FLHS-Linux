echo "
=====================================================================
Running a Lynis scan
=====================================================================
" >> $1/fluff.log

cd  $1/../Downloads/
    wget https://downloads.cisofy.com/lynis/lynis-3.0.8.tar.gz
    tar xfvz lynis-3.0.8.tar.gz > /dev/null 2>&1 
    
    cd lynis
        ./lynis audit system --no-colors >> $1/flush.log
    cd ..
cd ..
