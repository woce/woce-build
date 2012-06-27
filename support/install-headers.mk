# Install staging headers


BS_FOSS_TGZ := build-support-foss.tgz
BS_PALM_TGZ := build-support-palm.tgz

staging/armv7/usr/include/.staged: staging/$(WOCE_ARCH)/.unpacked $(BUILD_SUPPORT_DL)
	-rm -rf staging/armv7/usr/include
	mkdir -p staging/armv7/usr/include
	tar -zOxf $(BUILD_SUPPORT_DL) CE-build-support/$(BS_FOSS_TGZ) | \
		tar -C staging/armv7/usr/ --strip=1 -zx
	tar -zOxf $(BUILD_SUPPORT_DL) CE-build-support/$(BS_PALM_TGZ) | \
		tar -C staging/armv7/usr/ --strip=1 -zx
	tar -C staging/armv7/usr/lib --strip=4 -zxf $(BUILD_SUPPORT_DL) CE-build-support/staging/arm-none-linux-gnueabi/lib
	touch $@
