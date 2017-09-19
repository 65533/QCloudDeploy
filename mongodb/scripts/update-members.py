
import json
import sys

# extract config version
#version = 0
#rsfile = sys.argv[1]
#jsline = ""
#for line in open(rsfile):
#    jsline = line
#if len(jsline) > 0:
#    in_dict = json.loads(jsline)
#    conf_tag = "configVersion"
#    if "members" in in_dict:
#        for item in in_dict["members"]:
#            if conf_tag in item and item[conf_tag] > version:
#                version = item[conf_tag]

# collect members from conf
fname = "/opt/mongo/conf/members.txt"
addrs = []
with open(fname) as f:
    content = f.readlines()
    addrs = [x.strip() for x in content if len(x.strip()) > 0]

# set into json
dict = {}
dict["_id"] = "mt-set"
dict["members"] = []
#if version > 0:
#    dict["version"] = version + 1
for i in range(len(addrs)):
    sub = {}
    sub["_id"] = i
    pos = addrs[i].find(".")
    sub["host"] = addrs[i][pos + 1:]
    if addrs[i].find("secondary") != -1:
        sub["priority"] = 0
    dict["members"].append(sub)

print json.dumps(dict)
    
    
    
