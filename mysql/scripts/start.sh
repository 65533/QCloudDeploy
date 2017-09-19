#! /bin/bash

# set env
CmdPrefix=/usr/local
MySQLPrefix=$CmdPrefix/mysql-on-terarkdb
DataPrefix=/mysql_terarkdb
. $CmdPrefix/set-env.sh

touch $DataPrefix/sh.log
if [ "$#" -ne 1 ]; then
    echo "incorrect argument count: start.sh [master|slave]" >> sh.log
    exit 1
elif [ "$1" != "master" ] && [ "$1" != "slave" ]; then
    echo "invalid argument: start.sh [master|slave]" >> sh.log
    exit 1
fi

if [ "$1" == "master" ]; then
    cp -f $MySQLPrefix/conf/master.cnf $MySQLPrefix/my.cnf
else
    cp -f $MySQLPrefix/conf/slave.cnf $MySQLPrefix/my.cnf
fi

mkdir -p $DataPrefix/temp
mkdir -p $DataPrefix/log
if [ ! -d "$DataPrefix/data" ]; then
    cp -r $MySQLPrefix/data $DataPrefix/
fi

touch $DataPrefix/log/mysql_error.log
touch $DataPrefix/log/mysql.log

chown -R mysql:mysql $DataPrefix

#env LD_PRELOAD=libterark-zip-rocksdb-r.so:librocksdb.so \
env  TerarkZipTable_disableSecondPassIter=true \
    $MySQLPrefix/support-files/mysql.server start --defaults-file=$MySQLPrefix/my.cnf

sleep 20
