;STACK
ldi r16, low(RAMEND)
ldi r17, high(RAMEND)
out SPL, r16
out SPH, r17

;TIMER
// COM1A1 = Clear OC1A on compare, set at TOP
ldi r16, (1<<WGM11) | (1<<WGM10) | (1<<COM1A1)
ldi r17, (1<<WGM12) | (1<<CS10)			
sts TCCR1A, r16
sts TCCR1B, r17

ldi r16, 1<<PB5  ; timer led
out DDRB, r16

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
	out PORTA, r0; adc debug

	sts OCR1AH, r1 // high byte write first
	sts OCR1AL, r0
	
	rjmp main

	
