; -*- gas -*-

              org   0
              di
              jp    init
              ds    $200

              seek  $100
              org   $100
intvectors:
              dw    ignint
              dw    ignint
              dw    frameirq
              dw    ignint

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

              seek  $200
              org   $200
init:
              ld    sp, $ffff
              ;; Set up interrupts
              ld    a, intvectors >> 8
              ld    i, a
              im    2
              ei
              ;; Initialize hardware
              call  hwinit
              ;; Initialize counter value (for now)
              ld    hl, $0000
start:
              call  delay
              or    a
              ld    a, l
              inc   a
              daa
              ld    l, a
              jr    nc, start
              or    a
              ld    a, h
              inc   a
              daa
              ld    h, a
              jp    start
delay:
              push  af
              ld    a, 0
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

frameirq:
              push  af
              ei
              ld    a, c
              and   1
              jr    z, frame0
frame1:
              ld    a, c
              xor   1
              ld    c, a
              out   (pioadata), a
              ld    a, l
              out   (piobdata), a
              pop   af
              reti
frame0:
              ld    a, c
              xor   1
              ld    c, a
              out   (pioadata), a
              ld    a, h
              out   (piobdata), a
              pop   af
              reti

ignint:
              ei
              reti
	
hwinit:
              ;; Configure PIO port A as bits 0-1 output, 2-7 input
              ld    a, %00001111
              out   (pioacontrol), a
              ld    a, %11111100
              out   (pioacontrol), a
              ;; Configure PIO port B as outputs
              ld    a, %00000000
              out   (piobcontrol), a
              ld    a, %11111111
              out   (piobcontrol), a
              ;; Set CTC interrupt vector (0)
              ld    a, 0
              out   (ctc0), a
              ;; Set up CTC 0 and 1 to generate 1200 bps clock
              ld    a, %00000101
              out   (ctc0), a
              ld    a, 169
              out   (ctc0), a
              ld    a, %00000101
              out   (ctc1), a
              ld    a, 169
              out   (ctc1), a
              ;; Set up CTC 2 to generate a frame interrupt
              ld    a, %10100101
              out   (ctc2), a
              ld    a, 50
              out   (ctc2), a
              ;; Initialize SIO
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
