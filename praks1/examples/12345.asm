


main:
    ldi r16, 100 // M
	// (4*N - 3) * M - 1 (viimane iter) + 1
	loop:
		// 1 + 4*N - 1 (viimane iter) + 3 = 4*N - 3
		ldi r17, 100 // N
		loop1:
			nop
			dec r17
			brne loop1

		dec r16
		brne loop

	rjmp main
