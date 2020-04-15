
GALASM ?= galasm

all: sinope_gal.jed

.SUFFIXES: .jed .pld

.pld.jed:
	$(GALASM) $<

