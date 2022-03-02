ldi r17, 151

main_loop:
	delay_loop:
		nop
		dec r17
		brne delay_loop

	rjmp main_loop

// 1 iteretsioon = 1 + 4*151 - 1 = 604