include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: dwm

# Compile .c to .o
.c.o:
	${CC} -c ${CFLAGS} $<

# Dependencies
${OBJ}: config.h config.mk

# Generate config.h if it doesn't exist
config.h:
	cp config.def.h $@

# Link the binary
dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

# Clean build artifacts
clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz
	if [ -f config.h ]; then rm config.h; fi

# Create distributable tarball
dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk \
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c dwm-${VERSION}
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	gzip dwm-${VERSION}.tar
	rm -rf dwm-${VERSION}

# Install binary and man page
install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1

# Uninstall binary and man page
uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm \
		${DESTDIR}${MANPREFIX}/man1/dwm.1

.PHONY: all clean dist install uninstall

