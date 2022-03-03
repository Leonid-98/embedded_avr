// init
ldi r16, 0xff
out SPL, r16
ldi r16, 0x10
out SPH, r16

// 1 tact = 0.0005 ms = 0.5 us
// 1 ms / 0.0005 ms = 2000 tact
// r20, r21 global

ldi r16, 0xFF
ldi r17, 0
out 0x01, r16 // DDRA
out 0x02, r16 // PORTA

main:
	ldi r25, 3
	loop_lyhike:
		// poleb 100ms
		out 0x02, r16
		ldi r20, LOW(100)
		ldi r21, HIGH(100)
		call delay_r20r21_ms
		// kustus 100ms
		out 0x02, r17
		ldi r20, LOW(100)
		ldi r21, HIGH(100)
		call delay_r20r21_ms

		dec r25
		brne loop_lyhike
	
	out 0x02, r17

	ldi r25, 3
	loop_pikk:
		// kustus 500ms
		out 0x02, r17
		ldi r20, LOW(500)
		ldi r21, HIGH(500)
		call delay_r20r21_ms
		// poleb 500ms
		out 0x02, r16
		ldi r20, LOW(500)
		ldi r21, HIGH(500)
		call delay_r20r21_ms

		dec r25
		brne loop_pikk

	ldi r25, 3
	loop_lyhike1:
		// kustus 100ms
		out 0x02, r17
		ldi r20, LOW(100)
		ldi r21, HIGH(100)
		call delay_r20r21_ms
		// poleb 100ms
		out 0x02, r16
		ldi r20, LOW(100)
		ldi r21, HIGH(100)
		call delay_r20r21_ms

		dec r25
		brne loop_lyhike1

	// kustus 2000ms
		out 0x02, r17
		ldi r20, LOW(2000)
		ldi r21, HIGH(2000)
		call delay_r20r21_ms

rjmp main

delay_r20r21_ms:
	push r18
	push r19

	ldi r18, 1 // alumine
	ldi r19, 0 // ylemine
	delay_ms:
		call delay_1ms
		sub r20, r18
		sbc r21, r19
		brne delay_ms

	pop r19
	pop r18
	ret

delay_1ms:
    // 2000 cycles (t'pselt)
	push r16
	push r17
	push r18
	push r19

	ldi r18, 1 // alumine
	ldi r19, 0 // ylemine
	ldi r16, LOW(492)
	ldi r17, HIGH(492)
	delay_1ms_loop:
		sub r16, r18
		sbc r17, r19
		brne delay_1ms_loop

	pop r19
	pop r18
	pop r17
	pop r16
	nop
	ret

