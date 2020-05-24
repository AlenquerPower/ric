# makefile for ric

include config.mk


SRC= \
	src/ric.c\
	src/util.c

LIBRICSRC=\
	src/ric/hname.c\
	src/ric/nslook.c\
	src/ric/tcp_client.c\
	src/ric/tcp_server.c\
	src/ric/udp_client.c\
	src/ric/udp_server.c


PKGFILES=\
	LICENSE\
	Makefile\
	README.md\
	config.def.h\
	config.mk\
	man\
	src

LIBRICOBJ = ${LIBRICSRC:.c=.o}
OBJ = ${SRC:.c=.o}
BIN = ric libric.a

all: ${BIN}
	@echo "all built"

clean:
	@echo cleaning
	@rm -rf ${BIN} ${OBJ} ${LIBRICOBJ} ric-${VERSION} ric-${VERSION}.tar.gz

options:
	@echo "CC        = ${CC}"
	@echo "CFLAGS    = ${CFLAGS}"
	@echo "CPPFLAGS  = ${CPPFLAGS}"
	@echo "LDFLAGS   = ${LDFLAGS}"
	@echo "OBJ       = ${OBJ}"
	@echo "LIBRICOBJ = ${LIBRICOBJ}"
	@echo "BIN       = ${BIN}"

dist: clean
	mkdir -p ric-${VERSION}
	cp -r ${PKGFILES} ric-${VERSION}
	tar -cz  -f ric-${VERSION}.tar.gz ric-${VERSION}
	rm -r ric-${VERSION}

install: ric
	@echo installing executable file to ${PREFIX}/bin
	@mkdir -p ${PREFIX}/bin
	@cp -f ric ${PREFIX}/bin
	@chmod 755 ${PREFIX}/bin/ric
	@echo installing manual page to ${MANPREFIX}/man1
	@mkdir -p ${MANPREFIX}/man1
	@cp man/ric.1 ${MANPREFIX}/man1/ric.1
	@chmod 644 ${MANPREFIX}/man1/ric.1

uninstall:
	@echo removing executable file from ${PREFIX}/bin
	@rm -f ${PREFIX}/bin/ric ${MANPREFIX}/man1/ric.1

.c.o:
	@echo CC -c $<
	@${CC} ${CFLAGS} -c -o $@ $<

config.h: config.def.h
	cp config.def.h config.h

# ric program object files
src/ric.o: src/ric.c config.h include/ric.h
src/util.o: src/util.c config.h config.mk

# libric object files 
src/ric/hname.o: src/ric/hname.c
src/ric/nslook.o: src/ric/nslook.c
src/ric/tcp_client.o: src/ric/tcp_client.c
src/ric/tcp_server.o: src/ric/tcp_server.c
src/ric/udp_client.o: src/ric/udp_client.c
src/ric/udp_server.o: src/ric/udp_server.c

libric.a: ${LIBRICOBJ}
	@echo AR -o $@
	@ar rcs $@ ${LIBRICOBJ}

ric: ${OBJ} libric.a
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} libric.a ${LDFLAGS}

.PHONY: all clean dist install uninstall
