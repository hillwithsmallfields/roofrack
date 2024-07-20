#!/usr/bin/env python3

import re

outstream = None

with open("pieces.log") as instream:
    while line := instream.readline():
        line = line.removeprefix("ECHO: ")
        if m := re.match('"start of ([^"]+)', line):
            outstream = open(m.group(1).replace(' ', '-')+"-pieces.csv", 'w')
        elif line.startswith("end of"):
            outstream.close()
            outstream = None
        elif outstream:
            outstream.write(line)
