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

	// Timer init
	ldi r16, 0
	ldi r17, (1<<CS02) | (0<<CS01) | (1<<CS00) // 1024 prescaler = 101
	ldi r18, (1<<TOIE0) // overflow interrupt en
	out TCCR0A, r16
	out TCCR0B, r17
	sts TIMSK0, r18

	sei // global interrupt en

	ldi r16, 0xFF
	out DDRA, r16
	out PORTA, r16

	main_loop:
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
