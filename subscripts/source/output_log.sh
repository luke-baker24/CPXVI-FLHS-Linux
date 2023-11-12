#!/bin/bash

RED='\033[0;31m' #Red color code
NC='\033[0m' #No color code

directory=$1

output_log () {
    classification="$1"
    message="$2"
    
    echo -e "[ ${RED}$classification${NC} ] $message"
    echo "[ $classification ] $message" >> $directory/../../logs/output.log
}