#!/bin/bash

db="webapp"
table="logbook"
user="root"
pass=$(cat ./secrets.txt)

# check if the parameter exists
if [ "x$1" != "x" ]
then
    # if set to setup, run th emysql_secure_installation
    if [ $1 == "setup" ]
    then
        SECURE_MYSQL=$(expect -c "
        set timeout 3
        spawn mysql_secure_installation
        expect \"Enter current password for root (enter for none):\"
        send \"\r\"
        expect \"root password?\"
        send \"y\r\"
        expect \"New password:\"
        send \"$pass\r\"
        expect \"Re-enter new password:\"
        send \"$pass\r\"
        expect \"Remove anonymous users?\"
        send \"y\r\"
        expect \"Disallow root login remotely?\"
        send \"y\r\"
        expect \"Remove test database and access to it?\"
        send \"y\r\"
        expect \"Reload privilege tables now?\"
        send \"y\r\"
        expect eof
        ")

        #
        # Execution mysql_secure_installation
        #
        echo "${SECURE_MYSQL}"
    fi
fi


mysql -u$user -p$pass -e "create database if not exists $db"
mysql -u$user -p$pass -D$db -e "use $db; create table if not exists $table (id varchar(6), name varchar(50), message varchar(250), primary key(id));"
mysql -u$user -p$pass -D$db -e "use $db; insert into $table (id, name, message) values (\"123456\", \"Robert James\", \"Nice app!\"), (\"098765\", \"Alfred Raymond\", \"Submit works!\");"
