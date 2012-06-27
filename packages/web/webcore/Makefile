# webcore
# Extract needed headers, don't actually build yet.
# This also handles the npapi headers,
# which are partially pulled in from the isis-project repo.

LEVEL=../../..

include $(LEVEL)/Makefile.common

QTPATH := $(shell readlink -f $(LEVEL)/packages/sysmgr/qt4/build/armv7)
QMAKE := $(QTPATH)/bin/qmake-palm

.PHONY: build unpack patch
build:: build/.staged
unpack: build/src/.unpacked

WEBCORE_URL := http://downloads.help.palm.com/opensource/3.0.5/webcore.tgz
WEBCORE_PATCH_URL := http://downloads.help.palm.com/opensource/3.0.5/webcore-patch.gz
NPUPP_URL := "https://raw.github.com/isis-project/npapi-headers/72cc23fe0c94a36bdbeaac7323dae86a452f51df/debian/npapiheaders/usr/include/npupp.h"

WEBCORE_DL = $(DL_DIR)/webcore-3.0.5.tar.gz
WEBCORE_PATCH_DL = $(DL_DIR)/webcore-patch-3.0.5.gz

$(eval $(call DLTGZ,webcore,3.0.5,$(WEBCORE_URL)))
$(eval $(call DLGZ,webcore-patch,3.0.5,$(WEBCORE_PATCH_URL)))

build/src/.unpacked: $(WEBCORE_DL) $(WEBCORE_PATCH_DL)
	-rm -rf build
	mkdir -p build/src
	tar -C build/src --strip=1 -zxf $(WEBCORE_DL)
	# Ignore patch failures for now, it's a known issue
	-cd build/src && zcat ../../$(WEBCORE_PATCH_DL) | patch -p2 -fr -
	wget $(NPUPP_URL) -O build/npupp.h
	touch $@

# Copy needed headers over into appropriate location in the staging directory
WEBKIT_DIR := $(STAGING_DIR)/usr/include/webkit
build/.staged: build/src/.unpacked
	rm -f $@
	install -d $(WEBKIT_DIR)
	install -m 644 build/src/platform/graphics/pg/*.h $(WEBKIT_DIR)
	install -d $(WEBKIT_DIR)/npapi
	install -m 644 build/src/bridge/npapi.h $(WEBKIT_DIR)/npapi
	install -m 644 build/src/bridge/npruntime.h $(WEBKIT_DIR)/npapi
	install -m 644 build/src/plugins/npfunctions.h $(WEBKIT_DIR)/npapi
	install -m 644 build/npupp.h $(WEBKIT_DIR)/npapi
	touch $@

