// init stack
ldi r16, 0xff
out SPL, r16
ldi r16, 0x10
out SPH, r16

// TX en
ldi r16, 1<<TXEN1
sts UCSR1B, r16

// [2:1 char size=8bit]
ldi r16, 0b110
ldi r16, 1<<UCSZ11 | 1<<UCSZ10
sts UCSR1C, r16

// baud rate
ldi r16, low(12)
ldi r17, high(12)
sts UBRR1L, r16
sts UBRR1H, r17

main:
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

	rjmp main


uart_send_char:
	push r24
	push r16

	wait_for_empty:
		lds r16, UCSR1A // [6]USART Transmit Complete, [5] USART Data Register Empty
		andi r16, 0b0010_0000
		breq wait_for_empty

	sts UDR1, r24


	pop r16
	pop r24
	ret