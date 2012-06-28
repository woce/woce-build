# Useful definitions for downloading files

# Builds tar.bz2 dl rule
# Arguments: PREFIX (reads PREFIX_NAME, PREFIX_VERSION, and PREFIX_URL)
# Exports PREFIX_DL to be the resulting source target (for deps, etc)
define DLRULEBZ2
$1_DL := $(DL_DIR)/$($1_NAME)-$($1_VERSION).tar.bz2
$$($1_DL):
	rm -f $$@ $$@.tmp
	mkdir -p $(DL_DIR)
	curl -f -R -L -o $$@.tmp $($1_URL)
	mv $$@.tmp $$@
endef
EXTRACTRULEBZ2 = tar -C $2 $3 -axvf $($1_DL)

#
# Builds tar.gz dl rule
# Arguments: PREFIX (reads PREFIX_NAME, PREFIX_VERSION, and PREFIX_URL)
# Exports PREFIX_DL to be the resulting source target (for deps, etc)
define DLRULETGZ
$1_DL := $(DL_DIR)/$($1_NAME)-$($1_VERSION).tar.gz
$$($1_DL):
	rm -f $$@ $$@.tmp
	mkdir -p $(DL_DIR)
	curl -f -R -L -o $$@.tmp $($1_URL)
	mv $$@.tmp $$@
endef
EXTRACTRULETGZ = tar -C $2 $3 -axvf $($1_DL)

#
# Builds .gz dl rule
# Arguments: PREFIX (reads PREFIX_NAME, PREFIX_VERSION, and PREFIX_URL)
# Exports PREFIX_DL to be the resulting source target (for deps, etc)
define DLRULEGZ
$1_DL := $(DL_DIR)/$($1_NAME)-$($1_VERSION).gz
$$($1_DL):
	rm -f $$@ $$@.tmp
	mkdir -p $(DL_DIR)
	curl -f -R -L -o $$@.tmp $($1_URL)
	mv $$@.tmp $$@
endef
EXTRACTRULEGZ = $(error Cannot extract .gz to a directory)

# Builds tar.gz from specified git checkout
# Intended for exact git commit-id's as version
# Arguments: PREFIX (reads PREFIX_NAME, PREFIX_VERSION, and PREFIX_URL)
# Exports PREFIX_DL to be the resulting source target (for deps, etc)
# Keeps git checkout to help with updating costs
# Timestamp (used for make deps) is set to timestamp of commit
define DLRULEGIT
$1_DL := $(DL_DIR)/$($1_NAME)-$($1_VERSION).tar.gz
$$($1_DL):
	rm -f $$@
	mkdir -p $(DL_DIR)
	if [ ! -e $(DL_DIR)/$1-git ] ; then \
	  git clone -n $($1_URL) $(DL_DIR)/$1-git ; \
	elif [ -L $(DL_DIR)/$1-git ] ; then \
	  true ; \
	else \
	  ( cd $(DL_DIR)/$1-git ; git fetch ) ; \
	fi
	cd $(DL_DIR)/$1-git ; git checkout $($1_VERSION)
	tar -C $(DL_DIR)/$1-git -zcf $$@ .
	( cd $(DL_DIR)/$1-git ; git log --pretty="format:%ct" -n 1 $($1_VERSION) | \
	python -c 'import os,sys; time = int(sys.stdin.read()); os.utime("$$@",(time,time));'
endef
EXTRACTRULEGIT = tar -C $2 $3 -axvf $($1_DL)

# "DL" rule for directories on local machine.
# Extract rule symlinks to the specified directory
# (and doesn't support 'tar' options, which are almost always 'strip')
define DLRULEDIR
$1_DL := $($1_URL)/.exists
$$($1_DL):
	@touch $$@
endef
EXTRACTRULEDIR = rmdir $2; ln -s $($1_URL) $2

ifdef CONFIG
DLRULE = $(error No DLTYPE specified for $1, or missing config file!)
EXTRACTRULE = $(error No DLTYPE specified for $1, or missing config file!)
endif

# Looks up the specified DL information and invokes the appropriate rule
define DL
$(eval $(call DLRULE$($1_DLTYPE),$1))
endef
# Helper to 'extract' the various download types into a source directory
define EXTRACT
$(call EXTRACTRULE$($1_DLTYPE),$1,$2,$3)
endef
