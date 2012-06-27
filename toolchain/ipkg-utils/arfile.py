"""
arfile - A module to parse GNU ar archives.

Copyright (c) 2006-7 Paul Sokolovsky
This file is released under the terms 
of GNU General Public License v2 or later.
"""
import sys
import os
import tarfile 


class FileSection:
    "A class which allows to treat portion of file as separate file object."

    def __init__(self, f, offset, size):
        self.f = f
        self.offset = offset
        self.size = size
        self.seek(0, 0)

    def seek(self, offset, whence = 0):
#        print "seek(%x, %d)" % (offset, whence)
        if whence == 0:
            return self.f.seek(offset + self.offset, whence)
        elif whence == 1:
            return self.f.seek(offset, whence)
        elif whence == 2:
            return self.f.seek(self.offset + self.size + offset, 0)
        else:
            assert False

    def tell(self):
#        print "tell()"
        return self.f.tell() - self.offset

    def read(self, size = -1):
        if (size == -1): size = self.size
#        print "read(%d)" % size
        return self.f.read(size)

class ArFile:

    def __init__(self, f):
        self.f = f
        self.directory = {}
        self.directoryRead = False
        self.filenames = ""

        signature = self.f.readline()
        assert signature == "!<arch>\n"
        self.directoryOffset = self.f.tell()

    def open(self, fname):
        if self.directory.has_key(fname):
            return FileSection(self.f, self.directory[fname][-1], int(self.directory[fname][5]))

        if self.directoryRead:
            raise IOError, (2, "AR member not found: " + fname)

        f = self._scan(fname)
        if f == None:
            raise IOError, (2, "AR member not found: " + fname)
        return f


    def _scan(self, fname):
        self.f.seek(self.directoryOffset, 0)

        while True:
            l = self.f.readline()
            if not l: 
                self.directoryRead = True
                return None

            if l == "\n":
                l = self.f.readline()
                if not l: break
            descriptor = l.split()
#            print descriptor
            memberName = descriptor[0]

            # Handle GNU-style extended filenames
            if memberName[0] == '/':
                if memberName[1] == '/':
                    # Read past the extended directory
                    size = int(descriptor[1])
                    current = 0
                    while (current < size):
                        l = self.f.readline()
                        descriptor = l.split()
                        memberName = descriptor[0]
                        self.filenames = self.filenames + l +"\n"
                        current = current + len(l)
                    l = self.f.readline()
                    descriptor = l.split()
                    memberName = descriptor[0]
                else:
                    size = int(memberName[1:])
                    memberName = self.filenames[size:].split()[0]
                    descriptor[0] = memberName

            # Handle BSD-style extended filenames
            if memberName[0] == '#' and memberName[1] == '1' and memberName[2] == '/':
                # Read the extended directory
                size = int(memberName[3:])
                memberName = self.f.read(size)
                while (memberName[-1] == '\x00'):
                    memberName = memberName[:-1]
                descriptor[0] = memberName
                descriptor[5] = int(descriptor[5]) - size
                
            size = int(descriptor[5])
            if memberName[-1] == '/': memberName = memberName[:-1]
            self.directory[memberName] = descriptor + [self.f.tell()]
#            print "read:", memberName
            if memberName == fname or (memberName.startswith("`") and memberName[1:] == fname):
                # Record directory offset to start from next time
                self.directoryOffset = self.f.tell() + size
                return FileSection(self.f, self.f.tell(), size)

            # Skip data and loop
            if size % 2:
                size = size + 1
            data = self.f.seek(size, 1)
#            print hex(self.f.tell())

    def scan(self):
        self.f.seek(self.directoryOffset, 0)

        while True:
            l = self.f.readline()
            if not l: 
                self.directoryRead = True
                return None

            if l == "\n":
                l = self.f.readline()
                if not l: break
            descriptor = l.split()
#            print descriptor
            memberName = descriptor[0]

            # Handle GNU-style extended filenames
            if memberName[0] == '/':
                if memberName[1] == '/':
                    # Read past the extended directory
                    size = int(descriptor[1])
                    current = 0
                    while (current < size):
                        l = self.f.readline()
                        descriptor = l.split()
                        memberName = descriptor[0]
                        self.filenames = self.filenames + l
                        current = current + len(l)
                    l = self.f.readline()
                    descriptor = l.split()
                    memberName = descriptor[0]
                else:
                    size = int(memberName[1:])
                    memberName = self.filenames[size:].split()[0]
                    descriptor[0] = memberName

            # Handle BSD-style extended filenames
            if memberName[0] == '#' and memberName[1] == '1' and memberName[2] == '/':
                # Read the extended directory
                size = int(memberName[3:])
                memberName = self.f.read(size)
                while (memberName[-1] == '\x00'):
                    memberName = memberName[:-1]
                descriptor[0] = memberName
                descriptor[5] = int(descriptor[5]) - size

            size = int(descriptor[5])
            if memberName[-1] == '/': memberName = memberName[:-1]
            self.directory[memberName] = descriptor + [self.f.tell()]
#            print "read:", memberName

            # Skip data and loop
            if size % 2:
                size = size + 1
            data = self.f.seek(size, 1)
#            print hex(f.tell())


if __name__ == "__main__":
    if None:
        f = open(sys.argv[1], "rb")

        ar = ArFile(f)
        tarStream = ar.open("data.tar.gz")
        print "--------"
        tarStream = ar.open("data.tar.gz")
        print "--------"
        tarStream = ar.open("control.tar.gz")
        print "--------"
        tarStream = ar.open("control.tar.gz2")

        sys.exit(0)


    dir = "."
    if len(sys.argv) > 1:
        dir = sys.argv[1]
    for f in os.listdir(dir):
        if not f.endswith(".ipk"): continue

        print "=== %s ===" % f
        f = open(dir + "/" + f, "rb")

        ar = ArFile(f)
        tarStream = ar.open("control.tar.gz")
        tarf = tarfile.open("control.tar.gz", "r", tarStream)
        #tarf.list()

        f2 = tarf.extractfile("./control")
        print f2.read()
