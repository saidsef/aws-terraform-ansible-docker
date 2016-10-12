#!/usr/bin/env python

import sys
import re

path  = sys.argv[1]
ips = sys.argv[2]

with open(path + 'hosts.template', 'r') as template:
    with open(path + 'hosts', 'w') as ipf:
        for line in template:
            ips_nl = re.split("\n|\t|\r|\s", ips)
            ipf.write(line.replace('INSTANCES_IPS',"\n".join(ips_nl)))
