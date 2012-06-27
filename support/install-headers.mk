# Install staging headers

BUILD_SUPPORT_NAME := build-support
BUILD_SUPPORT_TAG := v0.0.1
BUILD_SUPPORT_URL := https://github.com/woce/$(BUILD_SUPPORT_NAME)/tarball/$(BUILD_SUPPORT_TAG)
BUILD_SUPPORT_DL := $(DL_DIR)/$(BUILD_SUPPORT_NAME)-$(BUILD_SUPPORT_TAG).tar.gz

$(eval $(call DLTGZ,$(BUILD_SUPPORT_NAME),$(BUILD_SUPPORT_TAG),$(BUILD_SUPPORT_URL)))

staging/armv7/usr/include/.staged: staging/$(WOCE_ARCH)/.unpacked $(BUILD_SUPPORT_DL)
	-rm -rf staging/armv7/usr/include
	mkdir -p staging/armv7/usr/include
	tar -C staging/armv7/usr/include --strip=4 --wildcards -zxf $(BUILD_SUPPORT_DL) 'woce-build-support-[a-f0-9]*/staging/arm-none-linux-gnueabi/include'
	tar -C staging/armv7/usr/lib --strip=4 --wildcards -zxf $(BUILD_SUPPORT_DL) 'woce-build-support-[a-f0-9]*/staging/arm-none-linux-gnueabi/lib'
	touch $@
