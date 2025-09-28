include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: rwm

# Compile .c to .o
.c.o:
	${CC} -c ${CFLAGS} $<

# Dependencies
${OBJ}: config.h config.mk

# Generate config.h if it doesn't exist
config.h:
	cp config.def.h $@

# Link the binary
rwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

# Clean build artifacts
clean:
	rm -f rwm ${OBJ} rwm-${VERSION}.tar.gz
	if [ -f config.h ]; then rm config.h; fi

# Create distributable tarball
dist: clean
	mkdir -p rwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk \
		rwm.1 drw.h util.h ${SRC} rwm.png transient.c rwm-${VERSION}
	tar -cf rwm-${VERSION}.tar rwm-${VERSION}
	gzip rwm-${VERSION}.tar
	rm -rf rwm-${VERSION}

# Install binary and man page
install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f rwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/rwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < rwm.1 > ${DESTDIR}${MANPREFIX}/man1/rwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/rwm.1

# Uninstall binary and man page
uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/rwm \
		${DESTDIR}${MANPREFIX}/man1/rwm.1

.PHONY: all clean dist install uninstall

