
GALASM ?= galasm

all: io_gal.jed memory_gal.jed

.SUFFIXES: .jed .pld

.pld.jed:
	$(GALASM) $<

