
# collect members from conf
fname = "/usr/local/mysql-on-terarkdb/conf/members.txt"
addrs = []
with open(fname) as f:
    content = f.readlines()
    addrs = [x.strip() for x in content if len(x.strip()) > 0]

master = ''
for addr in addrs:
    if addr.find("master") != -1:
        pos = addr.find("master") + len("master") + 1
        epos = addr.find(":")
        master = addr[pos : epos]
        break

print master
