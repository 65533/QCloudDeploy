
import json
import sys

filename = sys.argv[1]
jsline = ""
for line in open(filename):
    jsline = line

in_dict = json.loads(jsline)
out_dict = {}
for key, value in in_dict["opcounters"].items():
    out_dict[key] = value
for key, value in in_dict["connections"].items():
    out_dict[key] = value
print json.dumps(out_dict)

