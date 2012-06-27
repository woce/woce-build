# webkit handling
# Extract needed headers, don't actually build yet.

LEVEL=../../..

include $(LEVEL)/Makefile.common

QTPATH := $(shell readlink -f $(LEVEL)/packages/sysmgr/qt4/build/armv7)
QMAKE := $(QTPATH)/bin/qmake-palm

.PHONY: build unpack patch
build:: build/.staged
unpack: build/src/.unpacked

WEBKIT_URL := http://downloads.help.palm.com/opensource/3.0.5/webkit.tgz
WEBKIT_PATCH_URL := http://downloads.help.palm.com/opensource/3.0.5/webkit-patch.gz

WEBKIT_DL = $(DL_DIR)/webkit-3.0.5.tar.gz
WEBKIT_PATCH_DL = $(DL_DIR)/webkit-patch-3.0.5.gz

$(eval $(call DLTGZ,webkit,3.0.5,$(WEBKIT_URL)))
$(eval $(call DLGZ,webkit-patch,3.0.5,$(WEBKIT_PATCH_URL)))

build/src/.unpacked: $(WEBKIT_DL) $(WEBKIT_PATCH_DL)
	-rm -rf build
	mkdir -p build/src
	tar -C build/src --strip=1 -zxf $(WEBKIT_DL)
	# Ignore patch failures for now, it's a known issue
	-cd build/src && zcat ../../$(WEBKIT_PATCH_DL) | patch -p2 -fr -
	touch $@

# Copy needed headers over into appropriate location in the staging directory
WEBKIT_DIR := $(STAGING_DIR)/usr/include/webkit
build/.staged: build/src/.unpacked
	rm -f $@
	install -d $(WEBKIT_DIR)
	install -m 644 build/src/palm/webkit/*.h $(WEBKIT_DIR)
	install -m 644 build/src/palm/Api/*.h $(WEBKIT_DIR)
	install -m 644 build/src/palm/WebCoreSupport/WebGLES2Context.h $(WEBKIT_DIR)
	install -m 644 build/src/palm/WebCoreSupport/WebNonCopyable.h $(WEBKIT_DIR)
	touch $@

