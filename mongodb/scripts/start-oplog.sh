#! /bin/bash

# set env
. /opt/set-env.sh

if [ "$#" -ne 1 ]; then
    echo "incorrect argument count: start.sh [single|repl]"
    exit 1
elif [ "$1" != "single" ] && [ "$1" != "repl" ]; then
    echo "invalid argument: start.sh [single|repl]"
    exit 1
fi

mkdir -p /mongo_terocks/temp
mkdir -p /mongo_terocks/data
mkdir -p /mongo_terocks/log

Config=/opt/mongo/conf/mongod.conf
if [ "$1" == "single" ]; then
    Config=/opt/mongo/conf/mongod-single.conf
fi
echo "config is " $Config

env LD_PRELOAD=librocksdb.so:libterark-zip-rocksdb-r.so:libterark-core-r.so:libterark-fsa-r.so:libterark-zbs-r.so \
    TerarkZipTable_indexNestLevel=2 \
    TerarkZipTable_blackListColumnFamily=oplogCF \
    TerarkZipTable_indexCacheRatio=0.005 \
    TerarkZipTable_smallTaskMemory=1G \
    TerarkZipTable_softZipWorkingMemLimit=16G \
    TerarkZipTable_hardZipWorkingMemLimit=32G \
    TerarkZipTable_debugLevel=1 \
    /opt/mongo/mongod --storageEngine=rocksdb  --config=$Config --rocksdbSeparateOplogCF=1 --dbpath=/mongo_terocks/data &

sleep 20
