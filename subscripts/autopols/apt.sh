#!/bin/bash

#Clean software archives
apt clean
apt autoclean

#Configuring automatic updates
sudo apt install unattended-upgrades

systemctl restart unattended-upgrades
systemctl enable unattended-upgrades