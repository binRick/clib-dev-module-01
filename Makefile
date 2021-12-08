AR ?= ar
CC ?= gcc
PREFIX ?= ./bin
CFLAGS = -O3 -std=c99 -Wall -Wextra -Ideps -fPIC -I . -I module
SRCS = src/logger.c
OBJS = $(SRCS:.c=.o)

MAJOR_VERSION = 0
MINOR_VERSION = 2
PATCH_VERSION = 0

default: all

all: lib/liblogger.a lib/liblogger.so.$(MAJOR_VERSION).$(MINOR_VERSION).$(PATCH_VERSION) example1 test

init:
	mkdir -p bin lib

install: all
	echo ok

uninstall:
	echo ok

test: example1
	@./bin/$<

lib/liblogger.a: $(OBJS)
	@mkdir -p lib
	$(AR) rcs $@ $^

lib/liblogger.so.$(MAJOR_VERSION).$(MINOR_VERSION).$(PATCH_VERSION): $(OBJS)
	@mkdir -p lib
	ld -z now -shared -lc -soname `basename $@` src/*.o -o $@
	strip --strip-unneeded --remove-section=.comment --remove-section=.note $@

example1: example1.o $(OBJS)
	@mkdir -p bin
	$(CC) $^ -o ./bin/$@

%.o: %.c
	$(CC) $< $(CFLAGS) -c -o $@

clean:
	rm -fr bin lib *.o src/*.o

%.o: %.c
	$(CC) $< $(CFLAGS) -c -o $@

