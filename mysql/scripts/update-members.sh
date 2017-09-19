#!/bin/bash

# set env
CmdPrefix=/usr/local
MySQLPrefix=$CmdPrefix/mysql-on-terarkdb
DataPrefix=/mysql_terarkdb
. $CmdPrefix/set-env.sh

touch $DataPrefix/sh.log
if [ "$#" -ne 1 ]; then
    echo "incorrect argument count: update-members.sh [master|slave]" >> sh.log
    exit 1
elif [ "$1" != "master" ] && [ "$1" != "slave" ]; then
    echo "invalid argument: update-members.sh [master|slave]" >> sh.log
    exit 1
fi

# make sure all members are registered already
MemberCount=$(grep -v -e '^$' $MySQLPrefix/conf/members.txt | wc -l | cut -b1-2)
if [ "$MemberCount" -lt 2 ]; then
    echo "not a usable member-list, member count: " $MemberCount
    exit 1
fi
cat $MySQLPrefix/conf/members.txt >> sh.log

if [ "$1" == "master" ]; then
    $MySQLPrefix/bin/mysql -e "set global server_id = 1"
    sleep 20
    sh $MySQLPrefix/scripts/create-user.sh
else
    $MySQLPrefix/bin/mysql -e "set global server_id = 2"
    master=$(python $MySQLPrefix/scripts/extract-members.py)
    cmd="change master to master_host='$master', master_port=3306, master_user='root', master_password='', master_auto_position=1"
    $MySQLPrefix/bin/mysql -e "$cmd"
    $MySQLPrefix/bin/mysql -e "start slave"
fi

#echo "change master to master_host=\'$master\', master_port=3306, master_user=\'root\', master_password=\'\', master_auto_position=1"

echo $? >> sh.log
