;STACK
ldi r16, low(RAMEND)
ldi r17, high(RAMEND)
out SPL, r16
out SPH, r17

;TIMER
// COM1A1 = Clear OC1A on compare, set at TOP !!!
// WGM = 10bit fast PWM, CS = clk source no prescaling
ldi r16, 1<<WGM11 | 1<<WGM10 | 1<<COM1A1
ldi r17, 1<<WGM12 | 1<<CS10			
sts TCCR1A, r16
sts TCCr1B, r17

;ADC
ldi  r16, (1<<REFS0)|(1<<MUX1) //reference = VCC
sts  ADMUX, r16
ldi  r16, (1<<ADEN)|(1<<ADSC)|(1<<ADATE) //ADCENable, ADcStartConversion, ADcAutoTriggerEnable
sts  ADCSRA, r16

;LED
ldi r16, 0xFF
out DDRA, r16

main:
	wait_for_adc:
		ldi r16, ADCSRA
		// This bit is set when an ADC conversion completes
		andi r16, (1<<ADIF) 
		breq wait_for_adc
	lds r0, ADCL
	lds r1, ADCH

	sts OCR1BL, r0
	sts OCR1BH, r1

	;kui TCNT saab nulliks (TIFR0[0]), PWM = 1
	sts TIFR1, r16
	andi r16, 1<<TOV1 // Timer Count Overflow mask
	cpi r16, 1<<TOV1
	breq pwm_on

	;kui TCNT == OCRnB (TIFR0[3] == 1), PWM=0
	sts TIFR1, r16
	andi r16, 1<<OCF1B // Output Compare B mask
	cpi r16, 1<<OCF1B
	breq pwm_off
	
	rjmp main

pwm_on:
	ldi r16, 0xFF
	out PORTA, r16

	ldi r16, 1<<TOV1  // Clear overflow flag
	sts TIFR1, r16

	rjmp main

pwm_off:
	ldi r16, 0
	out PORTA, r16

	ldi r16, 1<<OCF1B  // Clear compare flag
	sts TIFR0, r16

	rjmp main
	
