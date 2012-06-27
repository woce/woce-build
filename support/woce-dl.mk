# Information about the big webos-WOCE tarball
WOCE_VERSION := unknown-1.0
WOCE_NAME := webos-WOCE
WOCE_URL := https://github.com/downloads/woce/LunaSysMgr/webOS-WOCE.tgz

# And the matching 'build-support' package
BUILD_SUPPORT_VERSION := unknown-1.0
BUILD_SUPPORT_NAME := CEbuild-support
BUILD_SUPPORT_URL := https://github.com/downloads/woce/build-support/CE-build-support.tgz

# Build rules for downloading these
$(eval $(call DLTGZ,$(WOCE_NAME),$(WOCE_VERSION),$(WOCE_URL)))
$(eval $(call DLTGZ,$(BUILD_SUPPORT_NAME),$(BUILD_SUPPORT_VERSION),$(BUILD_SUPPORT_URL)))

# And export their download locations
WOCE_DL = $(DL_DIR)/$(WOCE_NAME)-$(WOCE_VERSION).tar.gz
BUILD_SUPPORT_DL = $(DL_DIR)/$(BUILD_SUPPORT_NAME)-$(BUILD_SUPPORT_VERSION).tar.gz
