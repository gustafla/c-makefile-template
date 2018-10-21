TARGET=application
CC=gcc
PKGS=
CFLAGS+=$(shell pkg-config --cflags $(PKGS)) -O2 -s
LDLIBS+=$(shell pkg-config --libs $(PKGS))

SOURCES=main.c
OBJS=$(patsubst %.c,%.o,$(SOURCES))

$(TARGET): $(OBJS)
	$(CC) -o $(TARGET) $(CFLAGS) $(OBJS) $(LDLIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean

clean:
	rm -f $(TARGET) $(OBJS)
