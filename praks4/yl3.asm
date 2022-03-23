.dseg
led: .byte 1

.cseg
//STACK
ldi r16, low(RAMEND)
ldi r17, high(RAMEND)
out SPL, r16
out SPH, r17

//turn off JTAG
in r16, MCUCR
ldi r17, (1<<JTD) // JTAG Interface Disable
or r16, r17
out MCUCR, r16 // page 336
out MCUCR, r16

//IO PORTS
ldi r16, 0
ldi r17, 0xFF
out DDRF, r16 
out DDRA, r17

//VARIABLES
ldi r16, 1
sts led, r16
.equ joy_mask = 1<<PF4

main:
	lds r20, led
	out PORTA, r20

	in r20, PINF
	andi r20, joy_mask
	cpi r20, joy_mask
	brne continue
		call shift_led
	continue:

	wait_for_unpress:
		in r20, PINF
		andi r20, joy_mask
		cpi r20, 0
		brne wait_for_unpress

	rjmp main


shift_led:
	push r16
	lds r16, led

	lsl r16
	cpi r16, 0
	brne continue_shift
		ldi r16, 1 // if led != 0, skip this part
	continue_shift:

	sts led, r16
	pop r16
	ret
	
