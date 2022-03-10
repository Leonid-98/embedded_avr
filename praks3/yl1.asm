// mode
ldi r16, 0
sts 0x44, r16
// clk src
ldi r17, 0b000_0001
sts 0x45, r17



start:
    rjmp start