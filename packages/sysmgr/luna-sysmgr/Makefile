###  Packaging metadata
NAME  = lunasysmgrce
TITLE = LunaSysMgr CE
APP_ID   = org.webosports.${NAME}
SIGNER   = org.webosports
VERSION  = 4.0.0-ce-alpha
TYPE     = OS Application
CATEGORY = GUI 
HOMEPAGE = http://www.webos-ports.org/wiki/Application:LunaSysMgr-CE
	# TODO: Fix this icon! :)
ICON     = http://www.webos-internals.org/images/2/2c/LunaCommunityEdition.png
MAINTAINER = WebOS Ports
DESCRIPTION = ${APPINFO_DESCRIPTION}
APPINFO_DESCRIPTION = Luna SysManager is the user interface for webOS.<br>

CHANGELOG = \
4.0.0-ce-alpha: First Patched Release. \
3.0.5-ce: Initial testing release.

APPINFO_CHANGELOG = [ \
{ "version" : "4.0.0-ce-alpha",  "log" : [ "First Patched Release" ] }, \
{ "version" : "3.0.5-ce",  "log" : [ "Initial testing release" ] } \
]

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
package:: ipkgs/${APP_ID}-$(CONFIG)_${VERSION}_armv7.ipk
build:: build/$(CONFIG)/armv7-stage/.built-${VERSION}
unpack: build/$(CONFIG)/.unpacked

$(call DL,LUNASYSMGR)

### Unpack the software and build it
build/$(CONFIG)/.unpacked: $(LUNASYSMGR_DL)
	-rm -rf build/$(CONFIG)
	mkdir -p build/$(CONFIG)/src
	$(call EXTRACT,LUNASYSMGR,build/$(CONFIG)/src,--strip=1)
	touch $@

build/$(CONFIG)/armv7-stage/.config-${VERSION}: build/$(CONFIG)/.unpacked
	-rm -rf build/$(CONFIG)/armv7-stage
	mkdir -p build/$(CONFIG)/armv7-stage
	cd build/$(CONFIG)/armv7-stage && \
		$(CCENV) \
		PATH=$(QTPATH)/bin:$$PATH \
		$(QMAKE) ../src \
		-spec qws/linux-armv6-g++
	touch $@

build/$(CONFIG)/armv7-stage/.built-${VERSION}: build/$(CONFIG)/armv7-stage/.config-${VERSION}
	$(CCENV) $(MAKE) -C build/$(CONFIG)/armv7-stage

### Packaging magic
## TODO: When we revisit packaging, fix this up to do the 'right' thing regarding CONFIG
build/$(CONFIG)/.built-${VERSION}: build/$(CONFIG)/armv7.built-${VERSION}

### Headless app packaging fun
build/$(CONFIG)/%.built-${VERSION}: build/$(CONFIG)/%-stage/.built-${VERSION} ${DL_DIR}/headlessapp-${HEADLESSAPP_VERSION}.tar.gz
	rm -rf build/$(CONFIG)/$*
	mkdir -p build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}
	tar -C build/$(CONFIG)/$*/usr/palm/applications/${APP_ID} -xf ${DL_DIR}/headlessapp-${HEADLESSAPP_VERSION}.tar.gz
	rm -rf build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/.git
	tar -cf - icon.png | \
	tar -C build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/ -xf -
	tar -cf - LunaSysMgr_eventd | \
	tar -C build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/ -xf -
	mkdir -p build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/bin
	tar -C build/$(CONFIG)/$*-stage/release-topaz/ -cf - LunaSysMgr | \
	tar -C build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/bin/ -xf -
	mkdir -p build/$(CONFIG)/$*/usr/palm/applications/$(APP_ID)/tweaks
	for tj in `ls build/$(CONFIG)/src/conf/*.json| grep -v 'default-.*json'`; do \
		cp $$tj build/$(CONFIG)/$*/usr/palm/applications/$(APP_ID)/tweaks ; \
	done
	echo "{" > build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"title\": \"${TITLE}\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"id\": \"${APP_ID}\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"version\": \"${VERSION}\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"vendor\": \"WebOS Ports\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"type\": \"osApp\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"PostInstallFlags\": \"RestartLuna\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"PostUpdateFlags\": \"RestartLuna\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"PostRemoveFlags\": \"RestartLuna\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"main\": \"index.html\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"icon\": \"icon.png\"," >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
ifdef APPINFO_DESCRIPTION
	echo '"message": "${APPINFO_DESCRIPTION}",' >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
endif
ifdef APPINFO_CHANGELOG
	echo '"changeLog": ${APPINFO_CHANGELOG},' >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
endif
	echo '"uiRevision": "2",' >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "\"noWindow\": true" >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	echo "}" >> build/$(CONFIG)/$*/usr/palm/applications/${APP_ID}/appinfo.json
	touch $@

### CONTROL files
build/$(CONFIG)/%/CONTROL/postinst:
	rm -f $@
	mkdir -p build/$(CONFIG)/$*/CONTROL
	install -m 0775 control/postinst build/$(CONFIG)/$*/CONTROL
	chmod ugo+x $@

build/$(CONFIG)/%/CONTROL/prerm:
	rm -f $@
	mkdir -p build/$(CONFIG)/$*/CONTROL
	install -m 0775 control/prerm build/$(CONFIG)/$*/CONTROL
	chmod ugo+x $@

clobber::
	rm -rf build
