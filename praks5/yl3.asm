jmp main
.org 0x22 // Timer/Counter1 Compare Match A
jmp timer_interrupt
.org 0x4C
main:
	// Stack init
	ldi r16, low(RAMEND)
	ldi r17, high(RAMEND)
	out SPL, r16
	out SPH, r17

	// Timer init (PWM, phase and frequency Correct), 1024 prescaler
	ldi r16, (1<<WGM10) | (0<<WGM11) 
	ldi r17, (0<<WGM12) | (1<<WGM13) | (1<<CS12) | (0<<CS11) | (1<<CS10)	
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

	// led
	ldi r16, 0xFF
	out DDRA, r16
	out PORTA, r16

	main_loop:

		in r21, PINF
		andi r21, joy_mask
		cpi r21, joy_mask
			breq on_press
		
		ldi r20, 0    // blink delay bytes
		ldi r21, 128  // blink delay bytes
		sts OCR1AH, r20
		sts OCR1AL, r21
		rjmp main_loop

	on_press:
		ldi r20, 2  // blink delay bytes
		ldi r21, 0  // blink delay bytes
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