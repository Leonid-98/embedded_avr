// init
ldi r16, 0xff
out SPL, r16
ldi r16, 0x10
out SPH, r16

loop:
	LDI r16, 10
	OUT 0x05, r16
	CALL simple_procedure

	LDI r16, 20
	OUT 0x05, r16
	CALL simple_procedure

	LDI r16, 25
	OUT 0x05, r16
	CALL simple_procedure

	RJMP loop

simple_procedure:
	NOP
	RET


