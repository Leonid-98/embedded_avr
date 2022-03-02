// init
ldi r16, 0xff
out SPL, r16
ldi r16, 0x10
out SPH, r16


LDI r17, 10  // r17 = 10
LDI r18, 20  // r18 = 20
PUSH r17     // 10FF = 10, sp = 10FE
PUSH r18     // 10FE = 20, sp = 10FD
POP r17      // r17 = 20,  sp = 10FE
POP r18      // r18 = 10,  sp = 10FF
NOP

end:
    RJMP end