; -*- gas -*-

              org   0
              di
              jp    init
              ds    $100

sioadata:     equ   $80
sioacontrol:  equ   $81
siobdata:     equ   $82
siobcontrol:  equ   $83
ctc0:         equ   $84
ctc1:         equ   $85
ctc2:         equ   $86
ctc3:         equ   $87
pioadata:     equ   $88
pioacontrol:  equ   $89
piobdata:     equ   $8a
piobcontrol:  equ   $8b

rambase:      equ   $8000

              org   $100
              seek  $100
init:
              ld    sp, $ffff
              call  hwinit
	
start:
              ld    a, $12
              out   (piobdata), a
              ld    a, $01
              out   (pioadata), a
              call  delay
              ld    a, $34
              out   (piobdata), a
              ld    a, $00
              out   (pioadata), a
              call  delay
              jp    start
delay:
              push  af
              ld    a, #0
loop:
              call  nested
              inc   a
              djnz  loop
              pop   af
              ret
nested:
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              nop
              ret
	
hwinit:
              ;; configure PIO port A as bits 0-1 output, 2-7 input
              ld    a, %00001111
              out   (pioacontrol), a
              ld    a, %11111100
              out   (pioacontrol), a
              ;; configure PIO port B as outputs
              ld    a, %00001111
              out   (piobcontrol), a
              ld    a, %11111111
              out   (piobcontrol), a
              ;; set up ctc to generate 1200 bps clock
              ld    a, %00000101
              out   (ctc0), a
              ld    a, 169
              out   (ctc0), a
              ld    a, %00000101
              out   (ctc1), a
              ld    a, 169
              out   (ctc1), a
              ld    b, 12             ; load B with number of bytes (12)
              ld    hl, sio_init_data ; HL points to start of data
              ld    c, sioacontrol    ; I/O-port for write
              otir                    ; block write of B bytes to [C] starting from HL
              ret

sio_init_data:
              db    $00, %00110000  ; write to WR0: error reset
              db    $00, %00011000  ; write to WR0: channel reset
              db    $01, %00000000  ; write to WR1: no interrupts enabled
              db    $03, %11000001  ; write to WR3: enable RX 8bit
              db    $04, %00000100  ; write to WR4: clkx1, 1 stop bit, no parity
              db    $05, %01101000  ; write to WR5: DTR inactive, enable TX 8bit, BREAK off, TX on, RTS inactive
