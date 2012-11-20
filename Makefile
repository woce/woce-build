# Build WOCE goodness

WOCE_TOOLCHAIN=arm-2009q1
WOCE_ARCH=armv7

LEVEL = .

.PHONY: woce-toolchain woce-headers clobber
.PHONY: qt4 luna-sysmgr webkit-depends webkit
.PHONY: default woce webos-ports custom

include $(LEVEL)/Makefile.common

# To build packages, we need the toolchain and the staging dir setup
# For now, just list packages to be built here, in a working order.
build:: linkdirs
	$(MAKE) woce-toolchain woce-headers
	$(MAKE) webkitsupplemental
	$(MAKE) luna-sysmgr
	@echo
	@echo "Build Success!  New LunaSysMgr available at:"
	@echo `readlink -f packages/sysmgr/luna-sysmgr/build/$(CONFIG)/armv7-stage/release-topaz/LunaSysMgr`
	@echo

# For now, manually create phony targets for building each package,
# and also manually manage dependencies.
# Grabbing WIDK's DEPENDS and automatic target creation support
# should be done once this gets non-trivial to do by hand.
qt4:
	$(MAKE) -C packages/sysmgr/qt4

luna-sysmgr: qt4
	$(MAKE) -C packages/sysmgr/luna-sysmgr

webkit-depends: downloads/.zlib downloads/.freetype qt4

# This is a mess... Need to clean it up...
downloads/.zlib:
	scripts/get_zlib.sh $(LEVEL)
	touch $@

downloads/.freetype:
	scripts/get_freetype.sh $(LEVEL)
	touch $@

adapterbase:
	$(MAKE) -C packages/isis -f Makefile.AdapterBase

npapi:
	$(MAKE) -C packages/isis -f Makefile.npapi

pbnjson:
	$(MAKE) -C packages/isis -f Makefile.pbnjson

pmcertificatemgr:
	$(MAKE) -C packages/isis -f Makefile.pmcertmgr

browseradapter: npapi pbnjson adapterbase
	$(MAKE) -C packages/isis -f Makefile.BrowserAdapter

browserserver: browseradapter webkitsupplemental pmcertificatemgr
	$(MAKE) -C packages/isis -f Makefile.BrowserServer

webkit: webkit-depends
	$(MAKE) -C packages/isis -f Makefile.WebKit

webkitsupplemental: webkit
	$(MAKE) -C packages/isis -f Makefile.WebKitSupplemental

enyo1:
	echo "Need to do something about enyo1"

webview: enyo1
	echo "Need to do something about webview"

isis: browseradapter browserserver webview
	echo "We'll need to run a palm-package"

# Download and extract the toolchain
woce-toolchain: toolchain/$(WOCE_TOOLCHAIN)/.unpacked

# Grab the rootfs, stage it, and add our required headers
woce-headers: staging/$(WOCE_ARCH)/usr/include/.staged

# Cleanup everything other than the downloads (which are sacred)
clobber::
	rm -rf rootfs
	rm -rf staging
	rm -rf packages/sysmgr/*/build
