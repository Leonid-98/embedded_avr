ldi r16, 0xFF
out 0x01, r16

main_loop:
	out 0x02, r16
	inc r16

	ldi r17, 0xFF
	delay_loop:
		nop
		nop
		dec r17
		brne delay_loop

	rjmp main_loop

// 2 + 3 + (5*255 - 1) = 1279
// outer + inner + delay_loop