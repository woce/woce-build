# Build qt4

LEVEL=../../..

include $(LEVEL)/Makefile.common

.PHONY: build unpack patch
build:: build/armv7/.built
unpack:: build/src/.unpacked

VERSION := 4.8.0

QT4_URL := http://downloads.help.palm.com/opensource/3.0.5/qt4-$(VERSION).tar.gz
QT4_PATCH_URL := http://downloads.help.palm.com/opensource/3.0.5/qt-$(VERSION).patch.gz

QT4_DL = $(DL_DIR)/qt4-$(VERSION).tar.gz
QT4_PATCH_DL = $(DL_DIR)/qt4-patch-$(VERSION).gz

$(eval $(call DLTGZ,qt4,$(VERSION),$(QT4_URL)))
$(eval $(call DLGZ,qt4-patch,$(VERSION),$(QT4_PATCH_URL)))

build/src/.unpacked: $(QT4_DL) $(QT4_PATCH_DL) qt4.patch
	-rm -rf build
	mkdir -p build/src
	tar -C build/src --strip=1 -zxf $(QT4_DL)
	zcat $(QT4_PATCH_DL)| patch -Np1 -d build/src
	patch -Np2 -d build/src < qt4.patch
	cp qconfig-palm.h build/src/src/corelib/global/
	touch $@

build/armv7/.built: build/src/.unpacked
	-rm -rf build/armv7
	mkdir -p build/armv7
	@echo "Using armv6 mkspec, since for now the armv7 mkspec doesn't exist"
	+cd build/armv7 && \
		$(CCENV) \
		`readlink -f ../src`/configure \
		--prefix=$(STAGING_DIR)/usr \
		-opensource \
		-no-cups \
		-no-nis \
		-no-openssl \
		-no-exceptions \
		-no-accessibility \
		-no-qt3support \
		-no-xmlpatterns \
		-no-multimedia \
		-no-phonon \
		-no-phonon-backend \
		-no-svg \
		-no-webkit \
		-no-javascript-jit \
		-no-scripttools \
		-no-dbus \
		-no-gtkstyle \
		-no-xinput \
		-no-libtiff \
		-system-sqlite \
		-reduce-relocations \
		-glib \
		-opengl es2 \
		-confirm-license \
		-make 'tools' \
		-qpa \
		-arch armv7 \
		-xplatform qws/linux-armv6-g++ \
		-fast \
		-qconfig palm \
		-DPALM_DEVICE
	$(CCENV) $(MAKE) -C build/armv7 \
		 install_mkspecs \
		 install_qmake \
		 sub-moc-install_subtargets-ordered \
		 sub-uic-install_subtargets-ordered
	touch $@

