jmp a
.org 0x22 // Timer/Counter1 Compare Match A
jmp timer_interrupt
.org 0x32 // USART1 Rx Complete
jmp rx_interrupt

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

	// USART init
	ldi r16, 1<<TXEN1 | 1<<RXEN1 | 1<<RXCIE1 // RX interrupt en
	ldi r17, 1<<UCSZ11 | 1<<UCSZ10 // char size = 8 bit
	sts UCSR1B, r16
	sts UCSR1C, r17
	ldi r16, low(12)  // baud rate
	ldi r17, high(12)
	sts UBRR1L, r16
	sts UBRR1H, r17

	sei // global interrupt en

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
		ldi r24, 'n'
		call uart_send_char
		ldi r24, 'i'
		call uart_send_char
		ldi r24, 'd'
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

.equ zero = 48
.equ x_char = 88
rx_interrupt:
	push r16
	push r20
	push r21
	push r22
	in r22, SREG

	ldi r16, 0xFF
	out DDRA, R16

	lds r16, UDR1
	cpi r16, zero // ASCI CHAR 48
		breq led_off
	cpi r16, (zero + 1)
		breq led_1
	cpi r16, (zero + 2)
		breq led_2
	cpi r16, (zero + 3)
		breq led_3
	cpi r16, (zero + 4)
		breq led_4
	cpi r16, (zero + 5)
		breq led_5
	cpi r16, (zero + 6)
		breq led_6
	cpi r16, (zero + 7)
		breq led_7
	cpi r16, (zero + 8)
		breq led_8
	cpi r16, (zero + 9)
		breq led_9
	cpi r16, x_char
		breq led_on

	jmp continue2

	led_off:
		ldi r16, 0
		out PORTA, r16
		out DDRA, r16
		rjmp continue
	led_1:
		ldi r20, high(976)
		ldi r21, low(976)
		rjmp continue
	led_2:
		ldi r20, high(488)
		ldi r21, low(488)
		rjmp continue
	led_3:
		ldi r20, high(325)
		ldi r21, low(325)
		rjmp continue
	led_4:
		ldi r20, high(244)
		ldi r21, low(244)
		rjmp continue
	led_5:
		ldi r20, high(195)
		ldi r21, low(195)
		rjmp continue
	led_6:
		ldi r20, high(162)
		ldi r21, low(162)
		rjmp continue
	led_7:
		ldi r20, high(139)
		ldi r21, low(139)
		rjmp continue
	led_8:
		ldi r20, high(122)
		ldi r21, low(122)
		rjmp continue
	led_9:
		ldi r20, high(108)
		ldi r21, low(108)
		rjmp continue	
	led_on:
		ldi r20, high(1)
		ldi r21, low(1)
		

	continue:
	sts OCR1AH, r20
	sts OCR1AL, r21
	continue2:
	out SREG, r22
	pop r22
	pop r21
	pop r20
	pop r16
	reti