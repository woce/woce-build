TOOLCHAINS := arm-2007q3 arm-2009q1
arm-2007q3_VERSION := 2007q3-51-arm-none-linux-gnueabi-i686-pc-linux-gnu
arm-2009q1_VERSION := 2009q1-203-arm-none-linux-gnueabi-i686-pc-linux-gnu

TC_URL = https://sourcery.mentor.com/public/gnu_toolchain/arm-none-linux-gnueabi/arm-$1.tar.bz2

# Arguments: toolchain shortname
define TCRULE
$(TOOLCHAIN_DIR)/$1/.unpacked: $(DL_DIR)/arm-$($1_VERSION).tar.bz2
	rm -rf $(TOOLCHAIN_DIR)/$1
	-rm -rf $(TOOLCHAIN_DIR)/$1-tmp
	mkdir -p $(TOOLCHAIN_DIR)/$1-tmp
	tar -C $(TOOLCHAIN_DIR)/$1-tmp -jxf $$< $1
	mv $(TOOLCHAIN_DIR)/$1-tmp/$1 $(TOOLCHAIN_DIR)/$1
	rmdir $(TOOLCHAIN_DIR)/$1-tmp
	touch $$@
endef

# Build rules for extracting each toolchain
$(foreach t,$(TOOLCHAINS),$(eval $(call TCRULE,$t)))

# Build rules for downloading each toolchain
$(foreach t,$(TOOLCHAINS),$(eval $(call DLBZ2,arm,$($t_VERSION),$(call TC_URL,$($t_VERSION)))))
