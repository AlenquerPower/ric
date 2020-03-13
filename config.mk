# configuration of system

VERSION = 1.0.0


# installation
PREFIX ?= /usr/local/
MANPREFIX = ${PREFIX}/share/man


# compiler related
CC = gcc
INCS= -I. -I/usr/include
CPPFLAGS = -DVERSION=\"${VERSION}\" -D_POSIX_C_SOURCE=201112L -D_DEFAULT_SOURCE
CFLAGS = -W -Wall -std=c99 -pedantic ${CPPFLAGS} ${INCS}
LDFLAGS =
# for a future curses interface in a later day
#LDFLAGS = -lncurses -ltinfo