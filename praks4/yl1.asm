ldi r16, 0xff
out SPL, r16
ldi r16, 0x10
out SPH, r16

;---------------UART
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

;-----------ADC
ldi  r16, (1<<REFS0)|(1<<MUX1) //reference = AVCC (=VCC)
sts  ADMUX, r16
ldi  r16, (1<<ADEN)|(1<<ADSC)|(1<<ADATE)
sts  ADCSRA, r16
// ADEN  - ADC enable
// ADSC  - start conversion
// ADATE - auto tirgger enbable

;------LED
ldi r16, 0xFF
out ddra, r16

main:
	wait_for_convert:
		ldi r16, ADCSRA
		andi r16, (1<<ADIF)
		breq wait_for_convert

		lds   r1, ADCL
		lds   r2, ADCH
		
		ldi r25, -1
		call convert_adc_to_dec // r25 is counter

		ldi r24, 48
		add r24, r25
		call uart_send_char
		out porta, r24

	rjmp main

convert_adc_to_dec:
	push r1
	push r2
	push r16
	push r17

	loop:
		inc r25

		ldi r16, low(103)
		ldi r17, high(103)
		sub r1,r16
		sbc r2,r17
		brsh loop

	pop r17
	pop r16
	pop r2
	pop r1
	ret

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


	
