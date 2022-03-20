;STACK
ldi r16, low(RAMEND)
ldi r17, high(RAMEND)
out SPL, r16
out SPH, r17

;UART
.equ BAUD_RATE = 9600
.equ CLK_FREQ = 2000000
.equ SAMPLES = 16

ldi r16, 1<<TXEN1 // Transmitter en
sts UCSR1B, r16
ldi r16, 1<<UCSZ11 | 1<<UCSZ10 // [bit 2:1] char size=8bit
sts UCSR1C, r16
ldi r16, low(CLK_FREQ / (BAUD_RATE * SAMPLES) - 1) // 12
ldi r17, high(CLK_FREQ / (BAUD_RATE * SAMPLES) - 1)
sts UBRR1L, r16
sts UBRR1H, r17

;ADC
ldi  r16, (1<<REFS0)|(1<<MUX1) // reference = VCC
sts  ADMUX, r16
ldi  r16, (1<<ADEN)|(1<<ADSC)|(1<<ADATE) 
//ADC ENable, ADc Start Conversion, ADc Auto Trigger Enable
sts  ADCSRA, r16

;LED
ldi r16, 0xFF
out ddra, r16

// char '0' on number 48, '1' on 49 jne...
.equ ASCI_OFFSET = 48
.equ DEC_CONST = 103
main:
	wait_for_adc:
		ldi r16, ADCSRA
		// This bit is set when an ADC conversion completes
		andi r16, (1<<ADIF) 
		breq wait_for_adc

	lds  r0, ADCL
	lds  r1, ADCH

	// arvutan mitu korda saaks 103 lahutada
	ldi r25, -1
	count_value:
		inc r25

		ldi r16, low(DEC_CONST)
		ldi r17, high(DEC_CONST)
		sub r0, r16
		sbc r1, r17
		brsh count_value
		
	ldi r24, ASCI_OFFSET
	add r24, r25
	call uart_send_char_r25
	out porta, r24

	rjmp main

uart_send_char_r25:
	push r24
	push r16

	wait_for_empty:
		lds r16, UCSR1A 
		andi r16, 1<<UDRE1 // [Bit 5] USART Data Register Empty n
		breq wait_for_empty

	sts UDR1, r24

	pop r16
	pop r24
	ret


	
