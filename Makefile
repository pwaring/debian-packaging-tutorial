SHELL = /bin/sh
.SUFFIXES: .pod

all: notes.pdf

notes.pdf: notes.pod
	pod2pdf --title 'Debian Packaging Tutorial' notes.pod > notes.pdf

clean:
	-rm -f notes.pdf

distclean: clean

check:
	-podchecker -warnings -warnings -warnings notes.pod

.PHONY: all clean distclean check
