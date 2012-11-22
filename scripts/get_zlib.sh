#!/bin/bash

pushd .

CURRENTDIR=`pwd`
DOWNLOADS=downloads/zlib/

if [ ! -e $DOWNLOADS ]; then
	mkdir -p $DOWNLOADS
fi
cd $DOWNLOADS

wget http://downloads.help.palm.com/opensource/3.0.5/zlib-1.2.3.tar.bz2
wget http://downloads.help.palm.com/opensource/3.0.5/zlib-1.2.3-patches.tgz

tar -xvf zlib-1.2.3.tar.bz2
tar -xvf zlib-1.2.3-patches.tgz

rm zlib-1.2.3.tar.bz2
rm zlib-1.2.3-patches.tgz

cd zlib-1.2.3

patch -p1 < ../visibility.patch
patch -p1 -t < ../autotools.patch
patch -p1 -t < ../autotools.patch

chmod +x configure
./configure
make

cp zlib.h $CURRENTDIR/staging/armv7/usr/include/
cp zconf.h $CURRENTDIR/staging/armv7/usr/include/

touch .zlib

popd

