# Useful definitions for downloading files

# Builds tar.bz2 dl rule
# Arguments: NAME, VERSION, URL
define DLBZ2
$(DL_DIR)/$1-$2.tar.bz2:
	rm -f $$@ $$@.tmp
	mkdir -p $(DL_DIR)
	curl -f -R -L -o $$@.tmp $3
	mv $$@.tmp $$@
endef
#
# Builds tar.gz dl rule
# Arguments: NAME, VERSION, URL
define DLTGZ
$(DL_DIR)/$1-$2.tar.gz:
	rm -f $$@ $$@.tmp
	mkdir -p $(DL_DIR)
	curl -f -R -L -o $$@.tmp $3
	mv $$@.tmp $$@
endef

#
# Builds .gz dl rule
# Arguments: NAME, VERSION, URL
define DLGZ
$(DL_DIR)/$1-$2.gz:
	rm -f $$@ $$@.tmp
	mkdir -p $(DL_DIR)
	curl -f -R -L -o $$@.tmp $3
	mv $$@.tmp $$@
endef

# Builds tar.gz from specified git checkout
# Intended for exact git commit-id's as version
# Arguments: NAME, GITREV, URL
define DLGIT
$(DL_DIR)/$1-$2.tar.gz:
	rm -f $$@
	mkdir -p $(DL_DIR)
	if [ ! -e $(DL_DIR)/$1-git ] ; then \
	  git clone -n $3 $(DL_DIR)/$1-git ; \
	elif [ -L $(DL_DIR)/$1-git ] ; then \
	  true ; \
	else \
	  ( cd $(DL_DIR)/$1-git ; git fetch ) ; \
	fi
	cd $(DL_DIR)/$1-git ; git checkout $2
	tar -C $(DL_DIR)/$1-git -zcf $$@ .
	( cd $(DL_DIR)/$1-git ; git log --pretty="format:%ct" -n 1 $2 ) | \
	python -c 'import os,sys; time = int(sys.stdin.read()); os.utime("$$@",(time,time));'
endef
