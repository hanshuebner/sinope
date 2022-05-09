; -*- gas -*-

              org   0

sio0data:     equ   $80
sio0control:  equ   $81
sio1data:     equ   $81
sio1control:  equ   $82
ctc0:         equ   $83
ctc1:         equ   $84
ctc2:         equ   $85
ctc3:         equ   $86
pio0data:     equ   $87
pio0control:  equ   $88
pio1data:     equ   $89
pio1control:  equ   $8A

rambase:      equ   $8000

hwinit:
              ld    a, %00001111
              out   (pio0control), a
              out   (pio1control), a
                                    ; set up ctc to generate 1200 baud clock (?)
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
              ld    (hl), $55
              ld    a, %01010101
              out   (pio0data), a
              ld    a, %10101010
              out   (pio1data), a
              ld    (hl), $aa
              ld    a, %10101010
              out   (pio0data), a
              ld    a, %01010101
              out   (pio1data), a
              inc   hl
              ld    a, $80
              or    h
              ld    h, a
              jp    start
