# webos-ports.mk
#
# This file defines the sources used to drive the 'webos-ports' build.
#

$(warning The "webos-ports" build isn't supported yet.)
# Build-support
BUILD_SUPPORT_NAME := build-support
BUILD_SUPPORT_VERSION := v0.0.1
BUILD_SUPPORT_URL := https://github.com/webOS-ports/$(BUILD_SUPPORT_NAME)/tarball/$(BUILD_SUPPORT_VERSION)
BUILD_SUPPORT_DLTYPE := TGZ

# LunaSysMgr
LUNASYSMGR_NAME := WPLunaSysMgr
LUNASYSMGR_VERSION := v0.0.1
LUNASYSMGR_URL := https://github.com/webOS-ports/LunaSysMgr/tarball/$(LUNASYSMGR_VERSION)
LUNASYSMGR_DLTYPE := TGZ

# QT4 and patch
QT4_NAME := qt4
QT4_VERSION := 4.8.0
QT4_URL := http://downloads.help.palm.com/opensource/3.0.5/qt4-$(QT4_VERSION).tar.gz
QT4_DLTYPE := TGZ

QT4_PATCH_NAME := qt4-patch
QT4_PATCH_VERSION := $(QT4_VERSION)
QT4_PATCH_URL := http://downloads.help.palm.com/opensource/3.0.5/qt-$(QT4_VERSION).patch.gz
QT4_PATCH_DLTYPE := GZ
