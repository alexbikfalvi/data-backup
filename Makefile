#
#  Copyright (c) 2018 Alex Bikfalvi. All rights reserved.
#

# Determine the platform
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
	CC := clang++ -arch x86_64
else
	CC := g++
endif

SRCDIR := src
LIBDIR := lib
BUILDDIR := build
TARGETDIR := bin
INSTALLBINDIR := /usr/local/bin
TARGET := bin/data-backup

# Normal CPP files
SRCEXT := cpp
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))

CFLAGS := -c
ifeq ($(UNAME_S),Linux)
	CFLAGS += -std=gnu++11 -O2 # -fPIC
else
	CFLAGS += -std=c++11 -stdlib=libc++ -O2
endif

LIB := -L /usr/local/lib
INC := -I include -I /usr/local/include

$(TARGET): $(OBJECTS) $(OBJECTS2)
	@mkdir -p $(TARGETDIR)
	@echo " Linking..."
	@echo " $(CC) $^ -o $(TARGET) $(LIB)"; $(CC) $^ -o $(TARGET) $(LIB)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

$(BUILDDIR)/proto/%.o: $(SRCDIR)/proto/%.$(SRCEXT2)
	@mkdir -p $(BUILDDIR)
	@mkdir -p $(BUILDDIR)/proto
	@echo " $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

clean:
	@echo " Cleaning...";
	@echo " $(RM) -r $(BUILDDIR) $(TARGET)"; $(RM) -r $(BUILDDIR) $(TARGET)

install:
	@echo " Installing...";
	@echo " cp $(TARGET) $(INSTALLBINDIR)"; cp $(TARGET) $(INSTALLBINDIR)

distclean:
	@echo " Un-Installing...";
	@echo " rm /usr/local/bin/data-backup"; rm /usr/local/bin/data-backup

.PHONY: clean
