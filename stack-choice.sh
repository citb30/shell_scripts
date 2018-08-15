#!/bin/bash

## Script to install DB, APP, WEB Service in an order

LOG=/tmp/stack.log 
rm -f $LOG
ID=$(id -u)

TOMCAT_URL=$(curl -s https://tomcat.apache.org/download-90.cgi | grep tar.gz | grep nofollow | head -1 | cut -d '"' -f2)
TOMCAT_DIR=$(echo $TOMCAT_URL | awk -F / '{print $NF}' | sed -e 's/.tar.gz//')
TOMCAT_DIR="/opt/$TOMCAT_DIR"
WAR_URL='https://github.com/cit-aliqui/APP-STACK/raw/master/student.war'
WAR_FILE=$(echo $WAR_URL | awk -F / '{print $NF}')
JDBC_JAR_URL='https://github.com/cit-aliqui/APP-STACK/raw/master/mysql-connector-java-5.1.40.jar'
JDBC_JAR_FILE=$(echo $JDBC_JAR_URL | awk -F / '{print $NF}')
JDBC_CONN="<Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource" maxActive="50" maxIdle="30" maxWait="10000" username="student" password="student@1" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://$(hostname -i):3306/studentapp"/>"


error() {
    echo -e "\e[31m$1\e[0m"
}
Head() {
    echo -e "\n\t\e[36;4;1m$1\e[0m"
}

Print() {
    echo -n -e "-> $1 "
}

Stat() {
    if [ $1 == SKIP ]; then 
        echo -e " -- \e[33mSKIPPING\e[0m"
    elif [ $1 -eq 0 ]; then 
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
DB_SETUPF() {
    Head "Configuring DB Service"

    Print "Installing MariaDB Server"
    yum install mariadb-server -y &>>$LOG 
    Stat $?

    Print "Starting MariaDB Service"
    systemctl enable mariadb &>>$LOG 
    systemctl start mariadb &>>$LOG 
    Stat $?

    Print "Setting up schema"
    curl -s https://raw.githubusercontent.com/citb30/project-1/master/student.sql >student.sql 
    mysql <student.sql 
    Stat $?
}

## Install APP Service.
APP_SETUPF() {
    Head "Configuring APP Service"

    Print "Installing Java" 
    yum install java -y &>>$LOG 
    Stat $? 

    Print "Downloading and Extracting Tomcat"
    if [ -d $TOMCAT_DIR ]; then 
        Stat SKIP
    else 
        cd /opt
        wget -qO- $TOMCAT_URL | tar -xz 
        Stat $?
    fi 

    rm -rf $TOMCAT_DIR/webapps/* 
    Print "Downloading Student WAR"
    wget $WAR_URL -O $TOMCAT_DIR/webapps/$WAR_FILE &>>$LOG 
    Stat $?

    Print "Downloading JDBC JAR file"
    wget $JDBC_JAR_URL -O $TOMCAT_DIR/lib/$JDBC_JAR_FILE &>>$LOG 
    Stat $?

    sed -i -e '/TestDB/ d' -e"$ i $JDBC_CONN" $TOMCAT_DIR/conf/context.xml 

    ps -ef | grep java | grep -v grep &>/dev/null 
    if [ $? -eq 0 ]; then 
        Print "Stopping Tomcat"
        $TOMCAT_DIR/bin/shutdown.sh &>>$LOG 
        Stat $?
    fi 
    sleep 5
    Print "Starting Tomcat" 
    $TOMCAT_DIR/bin/startup.sh &>>$LOG 
    Stat $?

}

## Install APP Service.
WEB_SETUPF() {
    Head "Configuring WEB Service"

    Print "Installing HTTPD Server"
    yum install httpd -y &>>$LOG
    Stat $?

    Print "Downloading Mod_JK Library"
    wget https://github.com/citb30/project-1/raw/master/mod_jk.so -O /etc/httpd/modules/mod_jk.so &>>$LOG 
    Stat $?

    Print "Setting up Mod_JK Configurations"
    echo 'LoadModule jk_module modules/mod_jk.so
    JkWorkersFile conf.d/worker.properties
    JkMount /student local
    JkMount /student/* local' >/etc/httpd/conf.d/mod_jk.conf 
    echo 'worker.list=local
    worker.local.host=localhost
    worker.local.port=8009' >/etc/httpd/conf.d/worker.properties 
    Stat $? 

    Print "Starting HTTPD Server"
    systemctl enable httpd &>>$LOG 
    systemctl restart httpd &>>$LOG 
    Stat $?
}

