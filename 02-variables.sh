#!/bin/bash

SERVICE_NAME=TOMCAT

echo "Installing $SERVICE_NAME Service"
echo "Configuring $SERVICE_NAME Service"
echo "Changing $SERVICE_NAME Service Port Number"
echo "Starting $SERVICE_NAME Service"
echo "Checking $SERVICE_NAME Service"

echo

DATE=2018-08-09
echo "Good Morning, Today date is $DATE"

## Above date printing is a problem because it prints same date all the time
## In order to define a variable at run time you have command substitution.
### SYNTAX: VAR=$(command)  EX: DATE=$(date)

echo
DATE=$(date +%F)
echo "Good Morning, Today date is $DATE"
