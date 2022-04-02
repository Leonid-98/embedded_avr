jmp main
.org 0x2E // TIMER0 OVF
jmp timer_interrupt
.org 0x4C
main:
	// Stack init
	ldi r16, low(RAMEND)
	ldi r17, high(RAMEND)
	out SPL, r16
	out SPH, r17

	// Timer init (CTC mode), 1024 prescaler
	ldi r16, (0<<WGM10) | (0<<WGM11) 
	ldi r17, (1<<WGM12) | (0<<WGM13) | (1<<CS12) | (0<<CS11) | (1<<CS10)	
	ldi r18, 1<<OCIE1A  // interrupt en
	sts TCCR1A, r16
	sts TCCR1B, r17
	sts TIMSK1, r18

	//turn off JTAG
	in r16, MCUCR
	ldi r17, (1<<JTD) // JTAG Interface Disable
	or r16, r17
	out MCUCR, r16 // page 336
	out MCUCR, r16

	// joystick
	.equ joy_mask = (1<<PF4)
	ldi r16, 0
	ldi r17, joy_mask
	out DDRF, r16 
	out PORTF, r17

	sei // global interrupt en

	ldi r16, 0xFF
	out DDRA, r16
	out PORTA, r16

	main_loop:

		in r21, PINF
		andi r21, joy_mask
		cpi r21, joy_mask
			breq on_press
		
		ldi r20, 0
		ldi r21, 128
		sts OCR1AH, r20
		sts OCR1AL, r21
		rjmp main_loop

on_press:
	ldi r21, 0
	ldi r20, 2
	sts OCR1AH, r20
	sts OCR1AL, r21
	rjmp main_loop

timer_interrupt:
	push r16
	in r16, SREG
	push r16

	in r16, PORTA
	com r16
	out PORTA, r16

	pop r16
	out SREG, r16
	pop r16
	reti

delay_1ms:
	push r16

	ldi r16, (1<<OCF0B)
	out TIFR0, r16 // TIFR0 null
	ldi r16, 0
	out TCNT0, r16 // TCNT0 null
	ldi r16, 1
	out OCR0B, r16 // compare wih 1 (NB prescaler is 1024)

	loop:
		in r16, TIFR0
		andi r16, (1<<OCF0B)
	breq loop

	pop r16
	ret