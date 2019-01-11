DEBUG?=1

ifeq ($(DEBUG), 1)
BUILDDIR:=debug
CFLAGS:=-Og -g -fbounds-check -fno-omit-frame-pointer
LDLIBS:=-fsanitize=address -lasan
else
BUILDDIR:=release
CFLAGS:=-O2 -s
endif

TARGET:=$(BUILDDIR)/application
PREFIX:=~/.local
CC:=gcc
PKGS:=
CFLAGS+=$(shell pkg-config --cflags $(PKGS)) -std=c99 -Wall
LDLIBS+=$(shell pkg-config --libs $(PKGS))

SOURCES:=$(wildcard src/*.c)
OBJS:=$(patsubst %.c,%.o,$(SOURCES:src/%=$(BUILDDIR)/%))

$(TARGET): $(OBJS)
	$(info Linking $@)
	@$(CC) -o $(TARGET) $(CFLAGS) $(OBJS) $(LDLIBS)

$(BUILDDIR)/%.o: $(SOURCES)
	$(info Compiling $<)
	@$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean install

clean:
	rm -f $(TARGET) $(OBJS)

install: $(TARGET)
	cp $(TARGET) $(PREFIX)/bin
