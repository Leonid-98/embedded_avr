// init
ldi r16, 0xff
out SPL, r16
ldi r16, 0x10
out SPH, r16

main:
	LDI r16, 10
	OUT 0x05, r16
	CALL simple_procedure

	LDI r16, 20
	OUT 0x05, r16
	CALL smarter_procedure

	RJMP main

simple_procedure:
	NOP
	RET

smarter_procedure:
	CALL simple_procedure
	CALL simple_procedure
	RET


