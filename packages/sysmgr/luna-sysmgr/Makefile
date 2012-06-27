###  Packaging metadata
NAME  = lunasysmgr-ce
TITLE = LunaSysMgr-CE
APP_ID   = org.webos-community-edition.${NAME}
SIGNER   = org.webos-ports
VERSION  = 0.0.1
TYPE     = Application
CATEGORY = System Utilities
HOMEPAGE = http://www.webos-ports.org/wiki/Application:LunaSysMgr-CE
	# TODO: Fix this icon! :)
ICON     = http://www.webos-internals.org/images/a/a5/X.png
MAINTAINER = WebOS Ports
DESCRIPTION = ${APPINFO_DESCRIPTION}
APPINFO_DESCRIPTION = Luna SysManager is the user interface on webOS.<br>

CHANGELOG = \
0.0.1: Initial testing release.

APPINFO_CHANGELOG = [ \
{ "version" : "0.0.1",  "log" : [ "Initial testing release" ] } \

LICENSE  = Apache 2.0 License
HEADLESSAPP_VERSION = 0.2.0


LEVEL=../../..

# Default goal is to build LunaSysMgr
# There's a beta 'package' target as well that
# packages it up, but it's not ready yet!
build::
package::

include $(LEVEL)/Makefile.common
include $(LEVEL)/support/package.mk
include $(LEVEL)/support/headlessapp.mk

QTPATH := $(shell readlink -f $(LEVEL)/packages/sysmgr/qt4/build/armv7)
QMAKE := $(QTPATH)/bin/qmake-palm

.PHONY: build unpack patch package
package:: ipkgs/${APP_ID}_${VERSION}_armv7.ipk
build:: build/armv7-stage/.built-${VERSION}
unpack: build/src/.unpacked

### Unpack the software and build it
build/src/.unpacked: $(WOCE_DL) sysmgr.patch
	-rm -rf build
	mkdir -p build/src
	tar -C build/src --strip=2 -zxf $(WOCE_DL) webos-WOCE/luna-sysmgr
	patch -Np2 -d build/src < sysmgr.patch
	touch $@

build/armv7-stage/.built-${VERSION}: build/src/.unpacked
	-rm -rf build/armv7-stage
	mkdir -p build/armv7-stage
	cd build/armv7-stage && \
		$(CCENV) \
		PATH=$(QTPATH)/bin:$$PATH \
		$(QMAKE) ../src \
		-spec qws/linux-armv6-g++
	$(CCENV) $(MAKE) -C build/armv7-stage
	touch $@

### Packaging magic
build/.built-${VERSION}: build/armv7.built-${VERSION}
	touch $@

### Headless app packaging fun
build/%.built-${VERSION}: build/%-stage/.built-${VERSION} ${DL_DIR}/headlessapp-${HEADLESSAPP_VERSION}.tar.gz
	rm -rf build/$*
	mkdir -p build/$*/usr/palm/applications/${APP_ID}
	tar -C build/$*/usr/palm/applications/${APP_ID} -xf ${DL_DIR}/headlessapp-${HEADLESSAPP_VERSION}.tar.gz
	rm -rf build/$*/usr/palm/applications/${APP_ID}/.git
	tar -cf - control | \
	tar -C build/$*/usr/palm/applications/${APP_ID}/ -xf -
	mkdir -p build/$*/usr/palm/applications/${APP_ID}/bin
	tar -cf - replace.sh restore.sh | \
	tar -C build/$*/usr/palm/applications/${APP_ID}/bin/ -xf -
	tar -C build/$*-stage/release-topaz/ -cf - LunaSysMgr | \
	tar -C build/$*/usr/palm/applications/${APP_ID}/bin/ -xf -
	echo "{" > build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"title\": \"${TITLE}\"," >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"id\": \"${APP_ID}\"," >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"version\": \"${VERSION}\"," >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"vendor\": \"WebOS Ports\"," >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"type\": \"web\"," >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"main\": \"index.html\"," >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"icon\": \"icon.png\"," >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
ifdef APPINFO_DESCRIPTION
	echo '"message": "${APPINFO_DESCRIPTION}",' >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
endif
ifdef APPINFO_CHANGELOG
	echo '"changeLog": ${APPINFO_CHANGELOG},' >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
endif
	echo '"uiRevision": "2",' >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"noWindow\": true" >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "}" >> build/$*/usr/palm/applications/${APP_ID}/appinfo.json
	touch $@

### CONTROL files
build/%/CONTROL/postinst:
	rm -f $@
	mkdir -p build/$*/CONTROL
	install -m 0775 control/postinst build/$*/CONTROL
	chmod ugo+x $@

build/%/CONTROL/prerm:
	rm -f $@
	mkdir -p build/$*/CONTROL
	install -m 0775 control/prerm build/$*/CONTROL
	chmod ugo+x $@

clobber::
	rm -rf build
