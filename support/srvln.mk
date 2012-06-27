# Link directories from /srv/ if they exist...
$(LEVEL)/%/.created:
	@if [ ! -d $(@D) ]; then  \
		if [ -e /srv/$* ]; then \
			ln -sf /srv/$* $(@D); \
		else                    \
			mkdir -p $(@D);       \
		fi                      \
	fi
	@touch $@

.PHONY: linkdirs
linkdirs:: $(DL_DIR)/.created $(DOCTOR_DIR)/.created
