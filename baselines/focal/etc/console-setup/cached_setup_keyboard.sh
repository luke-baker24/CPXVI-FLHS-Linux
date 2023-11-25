#!/bin/sh

if [ -f /run/console-setup/keymap_loaded ]; then
    rm /run/console-setup/keymap_loaded
    exit 0
fi

