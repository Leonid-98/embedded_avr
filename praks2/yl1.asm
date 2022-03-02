// init
ldi r16, 0xff
out SPL, r16
ldi r16, 0x10
out SPH, r16

ldi r20, 10
ldi r21, 20

push r20
pop r21