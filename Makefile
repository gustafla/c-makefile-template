DEBUG?=1

ifeq ($(DEBUG), 0)
BUILDDIR:=release
CFLAGS:=-O2 -s -fno-plt -Wl,-O2,--sort-common,--as-needed,-z,relro,-z,now
else
BUILDDIR:=debug
CFLAGS:=-Og -g -fbounds-check -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer
endif

TARGET:=$(BUILDDIR)/application
PREFIX:=~/.local
CC:=gcc
PKGS:=
CFLAGS+=$(shell pkg-config --cflags $(PKGS)) -std=c99 -Wall -Wextra -Wpedantic
LDLIBS+=$(shell pkg-config --libs $(PKGS))

SOURCES:=$(wildcard src/*.c)
OBJS:=$(patsubst %.c,%.o,$(SOURCES:src/%=$(BUILDDIR)/%))

$(TARGET): $(OBJS)
	$(info Linking $@)
	@mkdir -p $(@D)
	@$(CC) -o $(TARGET) $(CFLAGS) $(OBJS) $(LDLIBS)

$(BUILDDIR)/%.o: $(SOURCES)
	$(info Compiling $<)
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean install

clean:
	rm -f $(TARGET) $(OBJS)

install: $(TARGET)
	cp $(TARGET) $(PREFIX)/bin
