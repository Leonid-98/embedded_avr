jmp main
.org 0x32
jmp rx_interrupt
.org 0x4C
main:
	// Stack init
	ldi r16, low(RAMEND)
	ldi r17, high(RAMEND)
	out SPL, r16
	out SPH, r17

	// rx en
	ldi r16, 1<<RXEN1 | 1<<TXEN1 | 1<<RXCIE1 // rx interrupt en
	ldi r17, 1<<UCSZ11 | 1<<UCSZ10 // char size = 8 bit
	sts UCSR1B, r16
	sts UCSR1C, r17
	ldi r16, low(12)  // baud rate
	ldi r17, high(12)
	sts UBRR1L, r16
	sts UBRR1H, r17

	sei // global interrupt

	// led
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
		ldi r24, ' '
		call uart_send_char
		
		rjmp main_loop

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

rx_interrupt:
    // TODO SREG!
	push r16
	lds r16, UDR1
	out PORTA, r16
	pop r16
	reti