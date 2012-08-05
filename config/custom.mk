# custom.mk
#
# This file defines the sources used to drive the 'custom' build.
#
# Override this to use your own development versions
# Each package needs a PREFIX_NAME, PREFIX_VERSION, and PREFIX_URL set
# As well as a PREFIX_DLTYPE to specify the source type.
# Valid dl types are: TGZ, BZ2, GZ, GIT, and DIR.
# The last directly uses the specified source tree, symlinking
# it into the appropriate build directory.

# Build-support
BUILD_SUPPORT_NAME := build-support
BUILD_SUPPORT_VERSION := v0.0.2
BUILD_SUPPORT_URL := https://github.com/woce/$(BUILD_SUPPORT_NAME)/tarball/$(BUILD_SUPPORT_VERSION)
BUILD_SUPPORT_DLTYPE := TGZ

# LunaSysMgr
LUNASYSMGR_NAME := LunaSysMgr
LUNASYSMGR_VERSION := v0.0.2
LUNASYSMGR_URL := ~/LunaSysMgr
LUNASYSMGR_DLTYPE := DIR

# QT4 and patch
QT4_NAME := qt4
QT4_VERSION := 4.8.0
QT4_URL := http://downloads.help.palm.com/opensource/3.0.5/qt4-$(QT4_VERSION).tar.gz
QT4_DLTYPE := TGZ

QT4_PATCH_NAME := qt4-patch
QT4_PATCH_VERSION := $(QT4_VERSION)
QT4_PATCH_URL := http://downloads.help.palm.com/opensource/3.0.5/qt-$(QT4_VERSION).patch.gz
QT4_PATCH_DLTYPE := GZ
