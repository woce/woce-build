#!/bin/bash

pushd .

CURRENTDIR=`pwd`
DOWNLOADS=downloads/freetype/

if [ ! -e $DOWNLOADS ]; then
        mkdir -p $DOWNLOADS
fi
cd $DOWNLOADS

wget http://downloads.help.palm.com/opensource/3.0.5/freetype-2.3.12.tar.bz2
wget http://downloads.help.palm.com/opensource/3.0.5/freetype-2.3.12-patches.tgz

tar -xvf freetype-2.3.12.tar.bz2
tar -xvf freetype-2.3.12-patches.tgz

cd freetype-2.3.12

patch -p1 < ../fix-configure.patch
patch -p1 < ../libtool-tag.patch
patch -p1 < ../files/no-hardcode.patch

cp include/* $CURRENTDIR/staging/armv7/usr/include/

touch .freetype

popd

