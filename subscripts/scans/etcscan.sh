#!/bin/bash

#Verify meld is installed on the system
if [[ $(which meld) ]]; then
    echo "Meld installed"
else
    echo "Meld is not installed."

    apt install meld
fi

#/etc/ scan
meld /etc/ $1/etc/