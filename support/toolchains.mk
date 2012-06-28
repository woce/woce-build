TOOLCHAINS := arm-2007q3 arm-2009q1
arm-2007q3_VERSION := 2007q3-51-arm-none-linux-gnueabi-i686-pc-linux-gnu
arm-2009q1_VERSION := 2009q1-203-arm-none-linux-gnueabi-i686-pc-linux-gnu

# Arguments: toolchain shortname
define TCRULE

$1_NAME := arm
$1_URL := https://sourcery.mentor.com/public/gnu_toolchain/arm-none-linux-gnueabi/arm-$($1_VERSION).tar.bz2
$1_DLTYPE := TGZ
$$(call DL,$1)

$(TOOLCHAIN_DIR)/$1/.unpacked: $$($1_DL)
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
