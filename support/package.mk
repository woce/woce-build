# Makefile for PreWare plugin packaging
#
# Copyright (C) 2009 by Rod Whitby <rod@whitby.id.au>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

ifndef NAME
PREWARE_SANITY += $(error "Please define NAME in your Makefile")
endif
ifndef TITLE
PREWARE_SANITY += $(error "Please define TITLE in your Makefile")
endif
ifndef VERSION
PREWARE_SANITY += $(error "Please define VERSION in your Makefile")
endif
ifndef APP_ID
PREWARE_SANITY += $(error "Please define APP_ID in your Makefile")
endif
ifndef TYPE
PREWARE_SANITY += $(error "Please define TYPE in your Makefile")
endif
ifndef CATEGORY
PREWARE_SANITY += $(error "Please define CATEGORY in your Makefile")
endif

ipkgs/${APP_ID}-${CONFIG}_${VERSION}_%.ipk: build/$(CONFIG)/.built-${VERSION}
	rm -f ipkgs/${APP_ID}-${CONFIG}_${VERSION}_$*.ipk
	rm -f build/$(CONFIG)/$*/CONTROL/conffiles
	${MAKE} build/$(CONFIG)/$*/CONTROL/conffiles
	rm -f build/$(CONFIG)/$*/CONTROL/control
	${MAKE} build/$(CONFIG)/$*/CONTROL/control
	rm -f build/$(CONFIG)/$*/CONTROL/postinst
	${MAKE} build/$(CONFIG)/$*/CONTROL/postinst
	rm -f build/$(CONFIG)/$*/CONTROL/prerm
	${MAKE} build/$(CONFIG)/$*/CONTROL/prerm
	rm -f build/$(CONFIG)/$*/CONTROL/conffiles
	${MAKE} build/$(CONFIG)/$*/CONTROL/conffiles
	mkdir -p ipkgs
	if [ -n "${SIGNER}" ] && [ -e $(LEVEL)/../../sign/${SIGNER}.crt ] && [ -e $(LEVEL)/../../sign/${SIGNER}.key ] ; then \
	  ( cd build/$(CONFIG) ; \
	    TAR_OPTIONS="--wildcards --mode=g-s" \
	    $(LEVEL)/../../toolchain/ipkg-utils/ipkg-build -o 0 -g 0 ${BLDFLAGS} \
	    -s $(shell cd $(LEVEL)/../.. ; pwd)/sign/${SIGNER}.crt -k $(shell cd $(LEVEL)/../.. ; pwd)/sign/${SIGNER}.key \
	    $* ) ; \
	else \
	  ( cd build/$(CONFIG) ; \
	    TAR_OPTIONS="--wildcards --mode=g-s" \
	    $(LEVEL)/../../toolchain/ipkg-utils/ipkg-build -o 0 -g 0 ${BLDFLAGS} $* ) ; \
	fi
	mv build/$(CONFIG)/${APP_ID}_${VERSION}_$*.ipk $@

build/$(CONFIG)/%/CONTROL/postinst:
	if [ -e control/postinst ] ; then \
	  install -m 755 control/postinst $@ ; \
	fi

build/$(CONFIG)/%/CONTROL/prerm:
	if [ -e control/prerm ] ; then \
	  install -m 755 control/prerm $@ ; \
	fi

build/$(CONFIG)/%/CONTROL/conffiles:
	if [ -e control/conffiles ] ; then \
	  install -m 755 control/conffiles $@ ; \
	fi

ifeq ("${TYPE}", "Application")
build/${CONFIG}/%/CONTROL/control: build/${CONFIG}/%/usr/palm/applications/${APP_ID}/appinfo.json
else ifdef SRC_OPTWARE
build/${CONFIG}/%/CONTROL/control: build/${CONFIG}/%.control
else
build/${CONFIG}/%/CONTROL/control: /dev/null
endif
	$(call PREWARE_SANITY)
	rm -f $@
	mkdir -p build/${CONFIG}/$*/CONTROL
	echo "Package: ${APP_ID}" > $@
	/bin/echo -n "Version: " >> $@
ifdef VERSION
	echo "${VERSION}" >> $@
else ifeq ("${TYPE}", "Application")
	sed -ne 's|^[[:space:]]*"version":[[:space:]]*"\(.*\)",[[:space:]]*$$|\1|p' $< >> $@
else
	echo "0.0.0" >> $@
endif
	echo "Architecture: $*" >> $@
	/bin/echo -n "Maintainer: " >> $@
ifdef MAINTAINER
	echo "${MAINTAINER}" >> $@
else ifeq ("${TYPE}", "Application")
	sed -ne 's|^[[:space:]]*"vendor":[[:space:]]*"\(.*\)",[[:space:]]*|\1|p' $< | tr -d '\n' >> $@
	/bin/echo -n " <" >> $@
	sed -ne 's|^[[:space:]]*"vendor_email":[[:space:]]*"\(.*\)",[[:space:]]*|\1|p' $< | tr -d '\n' >> $@
	echo ">" >> $@
else
	echo "WebOS Ports <woce@lists.webos-ports.org>" >> $@
endif
	/bin/echo -n "Description: " >> $@
ifdef TITLE
	echo "${TITLE}" >> $@
else ifeq ("${TYPE}", "Application")
	sed -ne 's|^[[:space:]]*"title":[[:space:]]*"\(.*\)",[[:space:]]*$$|\1|p' $< >> $@
else
	echo "${NAME}" >> $@
endif
ifdef CATEGORY
	echo "Section: ${CATEGORY}" >> $@
else
	echo "Section: Unsorted" >> $@
endif
ifdef PRIORITY
	echo "Priority: ${PRIORITY}" >> $@
else
	echo "Priority: optional" >> $@
endif
ifdef SRC_OPTWARE
ifdef DEPENDS
	echo "Depends: org.webosinternals.optware, ${DEPENDS}" >> $@
else
	echo "Depends: org.webosinternals.optware" >> $@
endif
else
	echo "Depends: ${DEPENDS}" >> $@
endif
ifdef CONFLICTS
	echo "Conficts: ${CONFLICTS}" >> $@
endif
	/bin/echo -n "Source: { " >> $@
ifdef SOURCE
	/bin/echo -n "\"Source\":\"${SOURCE}\", " >> $@
else ifdef SRC_IPKG
	/bin/echo -n "\"Source\":\"${SRC_IPKG}\", ">> $@
else ifdef SRC_TGZ
	/bin/echo -n "\"Source\":\"${SRC_TGZ}\", " >> $@
else ifdef SRC_ZIP
	/bin/echo -n "\"Source\":\"${SRC_ZIP}\", " >> $@
else ifdef SRC_GIT
	/bin/echo -n "\"Source\":\"${SRC_GIT}\", " >> $@
else ifdef SRC_OPTWARE
	/bin/echo -n "\"Source\":\"`sed -n -e 's|Source: \(.*\)|\1|p' build/$*.control`, http://trac.nslu2-linux.org/optware\", ">> $@
else
	true
endif
ifdef FEED
	/bin/echo -n "\"Feed\":\"${FEED}\"" >> $@
else ifdef SRC_OPTWARE
	/bin/echo -n "\"Feed\":\"Optware\"" >> $@
else
	/bin/echo -n "\"Feed\":\"WebOS Internals\"" >> $@
endif
ifdef TYPE
	/bin/echo -n ", \"Type\":\"${TYPE}\"" >> $@
endif
ifdef CATEGORY
	/bin/echo -n ", \"Category\":\"${CATEGORY}\"" >> $@
endif
ifdef SRC_IPKG
	/bin/echo -n ", \"LastUpdated\":\"" >> $@
	$(LEVEL)/scripts/timestamp.py ${DL_DIR}/${APP_ID}-${CONFIG}_${VERSION}_all.ipk >> $@
	/bin/echo -n "\"" >> $@
else ifdef SRC_TGZ
	/bin/echo -n ", \"LastUpdated\":\"" >> $@
	$(LEVEL)/scripts/timestamp.py ${DL_DIR}/${NAME}-${VERSION}.tar.gz >> $@
	/bin/echo -n "\"" >> $@
else ifdef SRC_ZIP
	/bin/echo -n ", \"LastUpdated\":\"" >> $@
	$(LEVEL)/scripts/timestamp.py ${DL_DIR}/${NAME}-${VERSION}.zip >> $@
	/bin/echo -n "\"" >> $@
else ifdef SRC_GIT
	/bin/echo -n ", \"LastUpdated\":\"" >> $@
	$(LEVEL)/scripts/timestamp.py ${DL_DIR}/${NAME}-${VERSION}.tar.gz >> $@
	/bin/echo -n "\"" >> $@
else ifdef SRC_OPTWARE
	/bin/echo -n ", \"LastUpdated\":\"" >> $@
	$(LEVEL)/scripts/timestamp.py ${DL_DIR}/${SRC_OPTWARE}_$*.ipk Makefile >> $@
	/bin/echo -n "\"" >> $@
else
	/bin/echo -n ", \"LastUpdated\":\"" >> $@
	$(LEVEL)/scripts/timestamp.py Makefile >> $@
	/bin/echo -n "\"" >> $@
endif
ifdef TITLE
	/bin/echo -n ", \"Title\":\"${TITLE}\"" >> $@
endif
	/bin/echo -n ", \"FullDescription\":\"" >> $@
ifdef DESCRIPTION
	/bin/echo -n "${DESCRIPTION}" >> $@
else ifdef SRC_OPTWARE
	/bin/echo -n "`sed -n -e 's|Description: \(.*\)|\1|p' build/$*.control`" >> $@
else ifdef TITLE
	/bin/echo -n "${TITLE}" >> $@
endif
ifdef CHANGELOG
	/bin/echo -n "<br>Changelog:<br>${CHANGELOG}" >> $@
endif
	/bin/echo -n "\"" >> $@
ifdef HOMEPAGE
	/bin/echo -n ", \"Homepage\":\"${HOMEPAGE}\"" >> $@
endif
ifdef ICON
	/bin/echo -n ", \"Icon\":\"${ICON}\"" >> $@
endif
ifdef SCREENSHOTS
	/bin/echo -n ", \"Screenshots\":${SCREENSHOTS}" >> $@
endif
ifdef LICENSE
	/bin/echo -n ", \"License\":\"${LICENSE}\"" >> $@
endif
ifdef POSTINSTALLFLAGS
	/bin/echo -n ", \"PostInstallFlags\":\"${POSTINSTALLFLAGS}\"" >> $@
endif
ifdef POSTUPDATEFLAGS
	/bin/echo -n ", \"PostUpdateFlags\":\"${POSTUPDATEFLAGS}\"" >> $@
endif
ifdef POSTREMOVEFLAGS
	/bin/echo -n ", \"PostRemoveFlags\":\"${POSTREMOVEFLAGS}\"" >> $@
endif
ifdef MINWEBOSVERSION
	/bin/echo -n ", \"MinWebOSVersion\":\"${MINWEBOSVERSION}\"" >> $@
endif
ifdef MAXWEBOSVERSION
	/bin/echo -n ", \"MaxWebOSVersion\":\"${MAXWEBOSVERSION}\"" >> $@
endif
ifdef DEVICECOMPATIBILITY
	/bin/echo -n ", \"DeviceCompatibility\":${DEVICECOMPATIBILITY}" >> $@
endif
ifdef PREINSTALLMESSAGE
	/bin/echo -n ", \"PreInstallMessage\":\"${PREINSTALLMESSAGE}\"" >> $@
endif
ifdef PREUPDATEMESSAGE
	/bin/echo -n ", \"PreUpdateMessage\":\"${PREUPDATEMESSAGE}\"" >> $@
endif
ifdef PREREMOVEMESSAGE
	/bin/echo -n ", \"PreRemoveMessage\":\"${PREREMOVEMESSAGE}\"" >> $@
endif
ifdef VISIBILITY
	/bin/echo -n ", \"Visibility\":\"${VISIBILITY}\"" >> $@
endif
	echo " }" >> $@
	touch $@

.PHONY: clobber
clobber::
	rm -rf ipkgs

.PHONY: clean
clean::
	rm -rf build/$(CONFIG)/src build/$(CONFIG)/src-* build/$(CONFIG)/arm build/$(CONFIG)/armv6 build/$(CONFIG)/armv7 build/$(CONFIG)/i686
