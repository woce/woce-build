# cross-compile variables
# little more hard-coded to armv7 than I'd like, but oh well.

STAGING_DIR = $(shell readlink -m $(LEVEL)/staging/armv7)
TCDIR = $(shell readlink -m $(LEVEL)/toolchain/arm-2009q1)
TCTOOLPREFIX = $(TCDIR)/bin/arm-none-linux-gnueabi-

CCENV := PATH=$(TCDIR)/bin:$(PATH)
CCENV += STAGING_LIBDIR=$(STAGING_DIR)/usr/lib
CCENV += STAGING_INCDIR=$(STAGING_DIR)/usr/include
CCENV += CC_TMP=$(TCTOOLPREFIX)gcc
CCENV += CXX_TMP=$(TCTOOLPREFIX)g++
CCENV += AR_TMP=$(TCTOOLPREFIX)ar
CCENV += OBJCOPY_TMP=$(TCTOOLPREFIX)objcopy
CCENV += STRIP_TMP=$(TCTOOLPREFIX)strip
CCENV += CFLAGS_TMP="-O2 -marm -march=armv7-a -ftree-vectorize -mfpu=neon -mfloat-abi=softfp -mtune=cortex-a8"
CCENV += CXXFLAGS_TMP="-O2 -marm -march=armv7-a -ftree-vectorize -mfpu=neon -mfloat-abi=softfp -mtune=cortex-a8"
ifdef MACHINE
	CCENV += MACHINE=$(MACHINE)
else
	CCENV += MACHINE=topaz
endif
