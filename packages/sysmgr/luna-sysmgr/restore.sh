#!/bin/sh

# Restore the original LunaSysMgr

NAME=LunaSysMgr-CE

APPNAME=LunaSysMgr

APPID=org.webos-ports.${NAME}

APPS=/media/cryptofs/apps

[ -d ${APPS} ] || { echo "Requires webOS 1.3.5 or later" ; exit 1 ; }

APPDIR=${APPS}/usr/palm/applications/${APPID}

# Stop the service if running
/sbin/stop ${APPNAME} || true

mount -o remount RW /

mv ${APPDIR}/LunaSysMgr.bak /usr/bin/LunaSysMgr

/sbin/start ${APPNAME}

mount -o remount RO /

exit 0
