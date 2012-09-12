#!/usr/bin/env python

import os
import sys

ps_output = os.popen("ps -ww -C python -o args").read()

something_missing = False
def process_status(description, ps_substring):
    global something_missing, ps_output
    print str(description) + ": ",
    if ps_output.find(ps_substring) > -1:
        print "OK"
    else:
        print "MISSING"
        something_missing = True

for (n, s) in [("keystone", "keystone-all"),
               ("glance API", "glance-api"),
               ("glance registry", "glance-registry"),
               ("nova network", "nova-network"),
               ("nova API", "nova-api"),
               ("nova scheduler", "nova-scheduler"),
               ("nova compute", "nova-compute")]:
    process_status(n, s)

if something_missing:
    sys.exit(1)
