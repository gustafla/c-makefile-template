TARGET=application
PREFIX=~/.local
CC=gcc
PKGS=
CFLAGS+=$(shell pkg-config --cflags $(PKGS)) -std=c99 -Wall
release:CFLAGS+=-O2 -s
debug:CFLAGS+=-Og -g -fbounds-check -fno-omit-frame-pointer
LDLIBS+=$(shell pkg-config --libs $(PKGS))
debug:LDLIBS+=-lasan

SOURCES=main.c
OBJS=$(patsubst %.c,%.o,$(SOURCES))

$(TARGET): $(OBJS)
	$(CC) -o $(TARGET) $(CFLAGS) $(OBJS) $(LDLIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean install debug release

debug: $(TARGET)

release: $(TARGET)

clean:
	rm -f $(TARGET) $(OBJS)

install: $(TARGET)
	cp $(TARGET) $(PREFIX)/bin
