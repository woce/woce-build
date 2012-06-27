# Build WOCE goodness

WOCE_TOOLCHAIN=arm-2009q1
WOCE_ARCH=armv7

LEVEL = .

.PHONY: woce-toolchain woce-headers clobber
.PHONY: qt4 luna-sysmgr

# To build packages, we need the toolchain and the staging dir setup
# For now, just list packages to be built here, in a working order.
build:: linkdirs
	$(MAKE) woce-toolchain woce-headers
	$(MAKE) luna-sysmgr
	@echo
	@echo "Build Success!  New LunaSysMgr available at:"
	@echo `readlink -f packages/sysmgr/luna-sysmgr/build/armv7-stage/release-topaz/LunaSysMgr`
	@echo

# For now, manually create phony targets for building each package,
# and also manually manage dependencies.
# Grabbing WIDK's DEPENDS and automatic target creation support
# should be done once this gets non-trivial to do by hand.
qt4:
	$(MAKE) -C packages/sysmgr/qt4

luna-sysmgr: qt4
	$(MAKE) -C packages/sysmgr/luna-sysmgr

# Download and extract the toolchain
woce-toolchain: toolchain/$(WOCE_TOOLCHAIN)/.unpacked

# Grab the rootfs, stage it, and add our required headers
woce-headers: staging/$(WOCE_ARCH)/usr/include/.staged
	$(MAKE) -C packages/web/webcore
	$(MAKE) -C packages/web/webkit

include $(LEVEL)/Makefile.common

# Cleanup everything other than the downloads (which are sacred)
clobber::
	rm -rf rootfs
	rm -rf staging
	rm -rf packages/sysmgr/*/build
	rm -rf packages/web/*/build
