# makefile for ric

include config.mk


SRC= \
	src/ric.c
#	src/hname.c\
#	src/nslook.c\
#	src/udp_client.c\
#	src/tcp_client.c\
#	src/udp_server.c\
#	src/tcp_server.c

PKGFILES=\
	LICENSE\
	Makefile\
	README.md\
	config.def.h\
	config.mk\
	man\
	src

OBJ= ${SRC:.c=.o}
BIN= ric

all: options ${BIN}
	@echo "all built"

clean:
	@echo cleaning
	@rm -rf ${BIN} ${OBJ} ric-${VERSION} ric-${VERSION}.tar.gz

options:
	@echo "CC        = ${CC}"
	@echo "CFLAGS    = ${CFLAGS}"
	@echo "CPPFLAGS  = ${CPPFLAGS}"
	@echo "LDFLAGS   = ${LDFLAGS}"
	@echo "OBJ       = ${OBJ}"
	@echo "BIN       = ${BIN}"

.c.o:
	@echo CC $<
	@${CC} ${CFLAGS} -c -o $@ $<

config.h: config.def.h
	cp config.def.h config.h

src/ric.o: src/ric.c config.h
src/hname.o: src/hname.c config.h
src/udp_client.o: src/udp_client.c config.h
src/tcp_client.o: src/tcp_client.c config.h
src/udp_server.o: src/udp_server.c config.h
src/tcp_server.o: src/tcp_server.c config.h

ric: ${OBJ}
	@echo CC -o $@
	@${CC} ${CFLAGS} -o $@ $^ ${LDFLAGS}

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

.PHONY: all clean dist install uninstall
