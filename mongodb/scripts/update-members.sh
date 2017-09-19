#!/bin/bash

# prepare env
. /opt/set-env.sh
touch /opt/mongo/bin/sh.log
echo "start script" > sh.log

if [ "$#" -ne 1 ]; then
    echo "incorrect argument count: update-members.sh [init|add|remove]" >> sh.log
    exit 1
elif [ "$1" != "init" ] && [ "$1" != "add" ] && [ "$1" != "remove" ]; then
    echo "invalid argument: update-members.sh [init|add|remove]" >> sh.log
    exit 1
fi

MongoHome=/opt/mongo
# make sure all members are registered already
MemberCount=$(grep -v -e '^$' $MongoHome/conf/members.txt | wc -l | cut -b1-2)
if [ "$MemberCount" -lt 2 ]; then
    echo "not a usable member-list, member count: " $MemberCount
    exit 1
fi
cat $MongoHome/conf/members.txt >> sh.log

# set rs versions
#touch $MongoHome/bin/rs_status.txt
#$MongoHome/mongo localhost:27017 --eval "JSON.stringify(db.adminCommand({'replSetGetStatus' : 1}))" > rs_status.txt 
#JsParam=$(python $MongoHome/bin/update-members.py $MongoHome/bin/rs_status.txt)
JsParam=$(python $MongoHome/bin/update-members.py)
echo "json output is: " $JsParam >> sh.log
if [ "$1" == "init" ]; then
    $MongoHome/mongo localhost:27017 --eval "JSON.stringify(db.adminCommand({'replSetInitiate' : $JsParam}))"
else
    $MongoHome/mongo localhost:27017 --eval "JSON.stringify(db.adminCommand({'replSetReconfig' : $JsParam}))"
fi

echo $? >> sh.log



