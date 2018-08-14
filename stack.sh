#!/bin/bash

## Script to install DB, APP, WEB Service in an order

LOG=/tmp/stack.log 
rm -f $LOG
ID=$(id -u)

error() {
    echo -e "\e[31m$1\e[0m"
}
Head() {
    echo -e "\t\e[36;4;1m$1\e[0m"
}

Print() {
    echo -n -e "-> $1 "
}

Stat() {
    if [ $1 -eq 0 ]; then 
        echo -e " -- \e[32mSUCCESS\e[0m"
    else
        echo -e " -- \e[31mFAILURE\e[0m"
        exit 1
    fi
}

if [ $ID -ne 0 ]; then 
    error "You should be a root user to perform this script"
    exit 2
fi

## Install DB Service.
Head "Configuring DB Service"

Print "Installing MariaDB Server"
yum install mariadb-server -y &>>$LOG 
Stat $?

Print "Starting MariaDB Service"
systemctl enable mariadb &>>$LOG 
systemctl start mariadb &>>$LOG 
Stat $?

Print "Setting up schema"
wget https://raw.githubusercontent.com/citb30/project-1/master/student.sql >studennt.sql &>>$LOG s
mysql <student.sql 
Stat $?