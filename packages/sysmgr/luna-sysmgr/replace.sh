#!/bin/sh

# Copy our new LunaSysMgr to the system
# Meant to be invoked only when LunaSysMgr isn't running

NAME=LunaSysMgr-CE

APPNAME=LunaSysMgr

# TODO: Abort if Luna is running!

mount -o remount RW /

/sbin/stop ${APPNAME} || true

if [ -e /usr/bin/LunaSysMgr.* ]
   mv /media/cryptofs/apps/usr/palm/applications/org.webos-community-edition.lunasysmgr-ce/bin/LunaSysMgr /usr/bin/LunaSysMgr
fi

mount -o remount RO /

/sbin/start ${APPNAME}

exit 0
