SERIAL=/dev/ttyUSB0

.SUFFIXES: .asm .bin

all: hwtest.bin
	memsim2 -d $(SERIAL) -m 27256 -r -100 -e $<

.asm.bin:
	z80asm -o $@ $<
