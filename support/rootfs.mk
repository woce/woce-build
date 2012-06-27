# armv7 rootfs rule
$(LEVEL)/rootfs/armv7/.unpacked: $(DOCTOR_DIR)/webosdoctorp305hstnhwifi-3.0.5.jar
	-rm -rf $(LEVEL)/rootfs/armv7
	mkdir -p $(LEVEL)/rootfs/armv7
	$(LEVEL)/scripts/unpack-doctor-rootfs $< $(LEVEL)/rootfs/armv7
	touch $@

# Fix linker scripts using absolute paths,
# and add some (needed) missing symlinks.
define fixlibs
	for lib in `grep -l "GNU ld script" -l $1/*.so`; do \
		mv $$lib $${lib}_orig; \
		sed 's@/usr/lib/@@g;s@/lib/@@g' $${lib}_orig > $$lib;\
	done
	cd $1 && ln -s libglib-2.0.so.0 libglib-2.0.so
	cd $1 && ln -s libgthread-2.0.so.0 libgthread-2.0.so
endef

# General staging rule
staging/%/.unpacked: rootfs/%/.unpacked
	-rm -rf staging/$*
	mkdir -p staging/$*
	cp -pR rootfs/$*/. staging/$*
	$(call fixlibs,staging/$*/usr/lib/)
	touch $@
