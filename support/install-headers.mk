# Install staging headers

$(call DL,BUILD_SUPPORT)

staging/armv7/usr/include/.staged: staging/$(WOCE_ARCH)/.unpacked $(BUILD_SUPPORT_DL)
	-rm -rf staging/armv7/usr/include
	mkdir -p staging/armv7/usr/include
	tar -C staging/armv7/usr/include --strip=4 --wildcards -axf $(BUILD_SUPPORT_DL) 'woce-build-support-[a-f0-9]*/staging/arm-none-linux-gnueabi/include'
	tar -C staging/armv7/usr/lib --strip=4 --wildcards -axf $(BUILD_SUPPORT_DL) 'woce-build-support-[a-f0-9]*/staging/arm-none-linux-gnueabi/lib'
	ln -s staging/armv7/usr/lib/libsqlite3.so.0 staging/armv7/usr/lib/libsqlite3.so
	touch $@
