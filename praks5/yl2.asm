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
	// TX en
	ldi r16, 1<<TXEN1
	ldi r17, 1<<UCSZ11 | 1<<UCSZ10 // char size = 8 bit
	sts UCSR1B, r16
	sts UCSR1C, r17
	ldi r16, low(12)  // baud rate
	ldi r17, high(12)
	sts UBRR1L, r16
	sts UBRR1H, r17

	sei // global interrupt en

	ldi r16, 0xFF
	out DDRA, r16
	out PORTA, r16

	main_loop:
			ldi r24, 'L'
			call uart_send_char

			ldi r24, 'e'
			call uart_send_char

			ldi r24, 'o'
			call uart_send_char

			ldi r24, 'n'
			call uart_send_char

			ldi r24, 'i'
			call uart_send_char

			ldi r24, 'd'
			call uart_send_char

			ldi r24, ' '
			call uart_send_char
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

uart_send_char:
	push r24
	push r16

	wait_for_empty:
		lds r16, UCSR1A 
		andi r16, 1<<UDRE1
		breq wait_for_empty
	sts UDR1, r24

	pop r16
	pop r24
	ret