#!/bin/bash

# prepare env
. /opt/set-env.sh > /dev/null
touch /opt/mongo/bin/status.txt

MongoHome=/opt/mongo
$MongoHome/mongo localhost:27017 --eval "JSON.stringify(db.runCommand({'serverStatus' : 1}))" > status.txt
python $MongoHome/bin/monitor.py status.txt
