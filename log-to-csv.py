#!/usr/bin/env python3

import re

outstream = None

with open("pieces.log") as instream:
    groups_seen = set()
    while line := instream.readline():
        line = line.removeprefix("ECHO: ")
        if m := re.match('"start of ([^"]+)', line):
            groupname = m.group(1).replace(' ', '-')
            if groupname in groups_seen:
                break
            groups_seen.add(groupname)
            outstream = open(groupname+"-pieces.csv", 'w')
        elif line.startswith("end of"):
            outstream.close()
            outstream = None
        elif outstream:
            outstream.write(line)
