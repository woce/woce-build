# Build qt4

LEVEL=../../..

include $(LEVEL)/Makefile.common

# Intentionally not making this rebuild for different
# CONFIG, until that's something we need.
# (qt4 takes a long time to configure+build!)
.PHONY: build unpack patch
build:: build/armv7/.built
unpack:: build/.unpacked

$(call DL,QT4)
$(call DL,QT4_PATCH)

build/.unpacked: $(QT4_DL) $(QT4_PATCH_DL) qt4.patch
	-rm -rf build
	mkdir -p build/src
	$(call EXTRACT,QT4,build/src,--strip=1)
	zcat $(QT4_PATCH_DL)| patch -Np1 -d build/src
	patch -Np2 -d build/src < qt4.patch
	cp qconfig-palm.h build/src/src/corelib/global/
	touch $@

build/armv7/.built: build/.unpacked
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
		 sub-uic-install_subtargets-ordered \
                 sub-network-install_subtargets-ordered \
                 sub-sql-install_subtargets-ordered \
                 sub-testlib-install_subtargets-ordered
	touch $@

