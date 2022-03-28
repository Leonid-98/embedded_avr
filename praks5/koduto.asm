;STACK
ldi r16, low(RAMEND)
ldi r17, high(RAMEND)
out SPL, r16
out SPH, r17

;TIMER
ldi r16, 0
ldi r17, (0<<CS02) | (1<<CS01) | (1<<CS00) // 1024 prescaler
out TCCR0A, r16
out TCCR0B, r17

;ADC
ldi  r16, (1<<REFS0)|(1<<MUX1) //reference = VCC
sts  ADMUX, r16
ldi  r16, (1<<ADEN)|(1<<ADSC)|(1<<ADATE) //ADCENable, ADcStartConversion, ADcAutoTriggerEnable
sts  ADCSRA, r16

;LED INIT
ldi r16, 0xFF
out DDRA, r16
ldi r16, (1<<PA0)
out PORTA, r16

.equ msb_mask = 0b10 // 10th bit in 16bit val
.equ xor_mask = 0b01 // 9th bit is only required
.equ stop_mask_h = 0b01 
.equ stop_mask_l = 0b1111_0000

main:
    // read adc value
	wait_for_adc:
		ldi r16, ADCSRA
		andi r16, (1<<ADIF) 
		breq wait_for_adc
	lds r20, ADCL
	lds r21, ADCH

	// check if in center (496 kuni 511 | 01 1111 xxxx)
	// kui ADC == 01_1111_xxxx, hypab tagasi
	mov r16, r20
	mov r17, r21
	andi r17, stop_mask_h
	cpi r17, stop_mask_h
		breq check_low_byte
		rjmp check_passed // no stop (arv ei ole vahemikus 486 kuni 511)
		check_low_byte:
			andi r16, stop_mask_l
			cpi r16, stop_mask_l
			breq main
	check_passed:

	// check whitch bit is MSB, detects side
	mov r16, r21
	andi r16, msb_mask // MSB is 10th bit
	cpi r16, msb_mask
		breq left_side  // if msb = 1
		rjmp right_side // else

	left_side:
		// invert 9-0 bit
		ldi r16, 0xFF
		eor r20, r16
		ldi r16, xor_mask
		eor r21, r16
		andi r21, xor_mask

		call shift_led_left
		rjmp continue_main

	right_side:
		call shift_led_right
		rjmp continue_main

	continue_main:

	// delay + 10ms
	ldi r16, 10
	ldi r17, 0
	add r20, r16
	adc r21, r17
	delay_ms:
		call delay_1ms
		subi r20, 1
		sbci r21, 0
		brne delay_ms
	
	rjmp main

shift_led_left:
	push r16
	in r16, PORTA

	lsl r16
	cpi r16, 0
	brne continue_shift
		ldi r16, (1<<PA0) // if led != 0, skip this part
	continue_shift:
	out PORTA, r16

	pop r16
	ret

shift_led_right:
	push r16
	in r16, PORTA

	lsr r16
	cpi r16, 0
	brne continue_shift2
		ldi r16, (1<<PA7) // if led != 0, skip this part
	continue_shift2:
	out PORTA, r16

	pop r16
	ret

delay_1ms:
	push r16

	ldi r16, (1<<OCF0B)
	out TIFR0, r16 // TIFR0 null
	ldi r16, 0
	out TCNT0, r16 // TCNT0 null
	ldi r16, 1
	out OCR0B, r16 // compare wih 1

	loop:
		in r16, TIFR0
		andi r16, (1<<OCF0B)
	breq loop

	pop r16
	ret