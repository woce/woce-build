#!/usr/bin/python

import os
import sys
import time

maxtime = 0
for file in sys.argv[1:]:
    (mode, ino, dev, nlink, uid, gid, size, atime, mtime, ctime) = os.stat(file)
    if (mtime > maxtime):
        maxtime = mtime

sys.stdout.write("%d" % maxtime);
