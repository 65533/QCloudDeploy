#!/bin/bash

# prepare env
. /usr/local/set-env.sh > /dev/null
MySQLHome=/usr/local/mysql-on-terarkdb
touch $MySQLHome/scripts/status.txt

$MySQLHome/bin/mysqladmin -u mysql extended-status > $MySQLHome/scripts/status.txt
python $MySQLHome/scripts/monitor.py $MySQLHome/scripts/status.txt
