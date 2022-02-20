ldi r16, 0xFF
out 0x04, r16 // DDRB

ldi r17, 0b01000000
ldi r18, 0b01000000 // XOR (eor) mask
out 0x05, r17 // PORTB

.macro wait_2000_tact
	ldi r21, 60	
	// ~60*33
	loop1:
		ldi r22, 10
		// ~33
		loop2:
			dec r22
			brne loop2
		dec r21
		brne loop1
.endmacro

main:
	eor r17, r18
	out 0x05, r17

	start: wait_2000_tact
	
rjmp main


