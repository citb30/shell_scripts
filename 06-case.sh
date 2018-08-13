#!/bin/bash

read -p 'Enter the Service to install[WEB|APP|DB]: ' service
service=$(echo $service | tr [a-z] [A-Z])
case $service in 
    WEB|web) echo "Installing WEB service" ;;
    APP) echo "Installing APP Service" ;;
    DB) echo "Installing DB Service" ;;
    *) echo "Invalid Service" ; exit 1 ;;
esac
