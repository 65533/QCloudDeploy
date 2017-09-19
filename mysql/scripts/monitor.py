
import json
import sys

fname = sys.argv[1]
out_dict = {}
lines = []
monitor_items = [ "Queries", "Com_commit", "Com_rollback", "Qcache_hits", "Threads_connected", "Slow_queries" ]

with open(fname) as f:
    content = f.readlines()
    lines = [x.strip() for x in content if len(x.strip()) > 0]

for line in lines:
    if line[0] == '+':
        continue
    elems = [x.strip() for x in line.split('|') if len(x.strip()) >0]
    if len(elems) > 0 and elems[0] in monitor_items:
        out_dict[elems[0]] = elems[1]

print json.dumps(out_dict)  


