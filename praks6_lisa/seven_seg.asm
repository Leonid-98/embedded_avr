.dseg
number: .byte 10
left: .byte 1
right: .byte 1

.cseg
jmp main

.org 0x2E // TIMER0 OVF
jmp fast_timer

.org 0x22 // Timer/Counter1 Compare Match A
jmp slow_timer

.org 0x4C


main:
	// Stack init
	ldi r16, low(RAMEND)
	ldi r17, high(RAMEND)
	out SPL, r16
	out SPH, r17

	// Timer init (PWM, phase and frequency Correct), 1024 prescaler // slow timer
	ldi r16, (1<<WGM10) | (0<<WGM11) 
	ldi r17, (0<<WGM12) | (1<<WGM13) | (1<<CS12) | (0<<CS11) | (1<<CS10)	
	ldi r18, 1<<OCIE1A  // interrupt en
	sts TCCR1A, r16
	sts TCCR1B, r17
	sts TIMSK1, r18

	// blink delay (slow timer)
	ldi r21, 0   
	ldi r20, 128
	sts OCR1AH, r21
	sts OCR1AL, r20

	

	sei // global interrupt en

	// led
	ldi r16, 0xFF
	out DDRA, r16
	out PORTA, r16

	// fill array
	ldi r26, low(number)
	ldi r27, high(number)
	ldi r16, 0b1111_1100  // 0
	st X+, r16
	ldi r16, 0b0110_0000 // 1
	st X+, r16
	ldi r16, 0b1101_1010 // 2
	st X+, r16
	ldi r16, 0b1111_0010 // 3
	st X+, r16
	ldi r16, 0b0110_0110 // 4
	st X+, r16
	ldi r16, 0b1011_0110 // 5
	st X+, r16
	ldi r16, 0b1011_1110 // 6
	st X+, r16
	ldi r16, 0b1110_0000 // 7
	st X+, r16
	ldi r16, 0b1111_1110 // 8
	st X+, r16
	ldi r16, 0b1111_0110 // 9
	st X+, r16

	// 7 seg init
	ldi r16, 0
	ldi r17, (1<<PE4) | (1<<PE3) // DS and SHCP
	out DDRE, r17 
	out PORTE, r16
	
	ldi r17, 1<<PB7
	out DDRB, r17
	out PORTB, r17

	ldi r16, 0
	ldi r17, 1<<PD4
	out DDRD, r17

	ldi r23, 0 // COUNTER ODD
	ldi r24, 0 // COUNTER RIGHT
	ldi r25, 0 // CONUTER LEFT
	ldi r20, 0 // CONST NUMBER TO SHOW
	main_loop:
		
		rjmp main_loop


slow_timer:
	push r16
	in r16, SREG
	push r16
	push r17
	push r26
	push r27

	in r16, porta
	com r16
	out porta, r16

	inc r24
	cpi r24, 10
		brne continue_slow
		ldi r24, 0
		inc r25
		cpi r25, 10
			brne continue_slow
			ldi r25, 0

	continue_slow:

	ldi r26, low(left)
	ldi r27, high(left)
	st X, r24
	
	ldi r26, low(right)
	ldi r27, high(right)
	st X, r25

	
	pop r27
	pop r26
	pop r17
	pop r16
	out SREG, r16
	pop r16
	reti

fast_timer:
	push r16
	in r16, SREG
	push r16
	push r26
	push r27

	andi r23, 1
	cpi r23, 1
	brne left_side
		// right
		ldi r16, 1<<PD4
		out PORTD, r16
		ldi r26, low(left)
		ldi r27, high(left)
		ld r20, X
		call shift_byte_out
		rjmp continue2
	left_side:
		// left
		ldi r16, 0
		out PORTD, r16
		ldi r26, low(right)
		ldi r27, high(right)
		ld r20, X
		call shift_byte_out
	continue2:
	inc r23

	pop r27
	pop r26
	pop r16
	out SREG, r16
	pop r16
	reti

shift_byte_out:
	push r27
	push r26
	push r18
	push r17
	push r16
	;push r20 // INC CONST
	push r21

	ldi r26, low(number)
	ldi r27, high(number)

	ldi r21, 0xff
	out pina, r21

	ldi r21, 0
	add r26, r20
	adc r27, r21

	ld r16, X // r16 on number

	ldi r18, 8 // r18 on loendur
	shift_loop:
		mov r17, r16 // r17 on viimane bitt
		andi r17, 1

		cpi r17, 1
			brne zero
			; case: 1 viimane bitt
			ldi r17, 1<<PE4
			out PORTE, r17
			ldi r17, (1<<PE4) | (1<<PE3)
			out PORTE, r17
			rjmp continue_shift
		zero:
			; case: 0 viimane bitt
			ldi r17, 0<<PE4
			out PORTE, r17
			ldi r17, (0<<PE4) | (1<<PE3)
			out PORTE, r17
		continue_shift:


		lsr r16
		dec r18
		brne shift_loop

	ldi r17, 1<<PB7
	out PORTB, r17
	ldi r17, 0
	out PORTB, r17

	pop r21
	;pop r20
	pop r16
	pop r17
	pop r18
	pop r26
	pop r27
	ret