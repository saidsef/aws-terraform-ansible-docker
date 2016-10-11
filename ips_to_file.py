#!/usr/bin/env python

import sys

path  = sys.argv[1]
ips = sys.argv[2]

with open(path + 'hosts.template', 'r') as template:
    with open(path + 'hosts', 'w') as ipf:
        for line in template:
            ipf.write(line.replace('INSTANCES_IPS',ips))
