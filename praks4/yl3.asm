//STACK
ldi r16, low(RAMEND)
ldi r17, high(RAMEND)
out SPL, r16
out SPH, r17

//turn off JTAG
in r16, MCUCR
ldi r17, (1<<JTD) // JTAG Interface Disable
or r16, r17
out MCUCR, r16 // page 336
out MCUCR, r16

//IO PORTS
.equ joy_mask_down = (1<<PF4)
.equ joy_mask_up = (1<<PF7)
ldi r16, 0
ldi r17, joy_mask_down | joy_mask_up
ldi r18, 0xFF
out DDRF, r16 
out PORTF, r17
out DDRA, r18

//TIMER
ldi r16, 0
ldi r17, (1<<CS02) | (1<<CS00) // 1024 prescaler
out TCCR0A, r16
out TCCR0B, r17

//LED INITIAL VAL
ldi r20, 1
out PORTA, r20
main:
	// shift left
	in r21, PINF
	andi r21, joy_mask_down

	cpi r21, joy_mask_down   // PF4=1 => skip shift
	breq continue1
		call shift_led_left
	continue1:

	// shift right
	in r21, PINF
	andi r21, joy_mask_up

	cpi r21, joy_mask_up   // PF4=1 => skip shift
	breq continue2
		call shift_led_right
	continue2:


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

	// wait after shift
	ldi r16, 255
	wait:
		call delay_1ms
		dec r16
		brne wait

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

	// wait after shift
	ldi r16, 255
	wait2:
		call delay_1ms
		dec r16
		brne wait2

	pop r16
	ret

delay_1ms:
	push r16

	ldi r16, (1<<OCF0B)
	out TIFR0, r16 // TIFR0 null
	ldi r16, 0
	out TCNT0, r16 // TCNT0 null
	ldi r16, 1
	out OCR0B, r16 // compare wih 1 (NB prescaler is 1024)

	loop:
		in r16, TIFR0
		andi r16, (1<<OCF0B)
	breq loop

	pop r16
	ret
	
