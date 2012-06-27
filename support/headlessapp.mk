HEADLESSAPP_SOURCE = git://git.webos-internals.org/applications/headlessapp.git

${DL_DIR}/headlessapp-${HEADLESSAPP_VERSION}.tar.gz:
	rm -f $@
	rm -rf build/headlessapp
	mkdir -p build
	( cd build ; git clone -n ${HEADLESSAPP_SOURCE} ; cd headlessapp ; git checkout v${HEADLESSAPP_VERSION} )
	rm -f build/headlessapp/appinfo.json build/headlessapp/icon.png
	mkdir -p ${DL_DIR}
	tar -C build/headlessapp -zcf $@ .
	( cd build/headlessapp ; git log --pretty="format:%ct" -n 1 v${HEADLESSAPP_VERSION} ) | \
	python -c 'import os,sys; time = int(sys.stdin.read()); os.utime("$@",(time,time));'
