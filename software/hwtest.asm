; -*- gas -*-

              org   0
              jp    init

sio0data:     equ   $80
sio0control:  equ   $81
sio1data:     equ   $82
sio1control:  equ   $83
ctc0:         equ   $84
ctc1:         equ   $85
ctc2:         equ   $86
ctc3:         equ   $87
pio0data:     equ   $88
pio0control:  equ   $89
pio1data:     equ   $8A
pio1control:  equ   $8B

rambase:      equ   $8000

init:
              ld    sp, $ffff
hwinit:
              ;; configure PIO as outputs
              ld    a, %00001111
              out   (pio0control), a
              out   (pio1control), a
              ;; set up ctc to generate 1200 bps clock
              ld    a, %00000101
              out   (ctc0), a
              ld    a, 169
              out   (ctc0), a
              ld    a, %00000101
              out   (ctc1), a
              ld    a, 169
              out   (ctc1), a
              ld    hl, $8000
start:
              ld    a, $21
              out   (pio1data), a
              ld    a, $01
              out   (pio0data), a
              call  delay
              ld    a, $43
              out   (pio1data), a
              ld    a, $00
              out   (pio0data), a
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