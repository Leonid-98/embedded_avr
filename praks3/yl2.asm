ldi r21, 0xFF
ldi r20, 0
out ddra, r21 // DDRA
out porta, r21 // PORTA


// init stack
ldi r16, 0xff
out SPL, r16
ldi r16, 0x10
out SPH, r16

// timer: normal mode
ldi r16, 0
sts 0x44, r16 // WGM02_0 = 0
// clk src (TCCR0B)
ldi r17, 0b000_0101
sts 0x45, r17

main:
	;call delay_1ms
	ldi r20, LOW(200)
	ldi r21, HIGH(200)

	// divide r24:r23  by 32  
	mov r23, r20
	mov r24, r21
	ldi r30, 5
	divide_by_32:
		lsr r24
		ror r23
		dec r30
		brne divide_by_32
	
	// divide r25:r26  by 128 
	mov r25, r20
	mov r26, r21
	ldi r30, 7
	divide_by_128:
		lsr r26
		ror r25
		dec r30
		brne divide_by_128
	
	; Subtract r24:r23 from r21:r20
	sub r20,r23
	sbc r21,r24

	// r21:r20 + r25:r26
	add r20,r25
	adc r21,r26


	call delay_r20r21_ms
	

	rjmp main

delay_1ms:
push r17
push r16
push r20

ldi r20, (1<<OCF0B)
out tifr0, r20 // TIFR0 null
ldi r20, 0
sts 0x46, r20 // TCNT0 null

ldi r17, 1
sts 0x48, r17
loop:
	in r16, 0x15
	andi r16, 0b0000_100
breq loop

pop r20
pop r16
pop r17

ret

delay_r20r21_ms:
push r20
push r21

delay_ms:
	call delay_1ms
	subi r20, 1
	sbci r21, 0
	brne delay_ms

pop r21
pop r20
ret


