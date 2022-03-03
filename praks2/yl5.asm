// init
ldi r16, 0xff
out SPL, r16
ldi r16, 0x10
out SPH, r16


ldi r16, 0xFF
ldi r17, 0
out 0x01, r16 // DDRA
out 0x02, r16 // PORTA

main:
	call kolm_korda1

	call delay 
	call delay

	call kolm_korda2

	call delay
	call delay

	call kolm_korda1

	call delay
	call delay
	call delay
	call delay
	call delay
	call delay

rjmp main

kolm_korda1:
	push r16
	push r17
	push r20

	ldi r20, 3
	loop0:
		out 0x02, r16 // led polema
		call delay
		out 0x02, r17 // led kustu
		call delay

		dec r20
		brne loop0

	pop r20
	pop r17
	pop r16
	ret

kolm_korda2:
	push r16
	push r17
	push r20

	ldi r20, 3
	loop1:
		out 0x02, r16 // led polema
		call delay
		call delay
		call delay
		out 0x02, r17 // led kustu
		call delay
		
		dec r20
		brne loop1

	pop r20
	pop r17
	pop r16
	ret

// 999_999 tacts delay
delay:
	push r20
	push r21
	push r22
	ldi r20, 33
		loop00:
			ldi r21, 100
			loop11:
				ldi r22, 100 
				loop22:
					dec r22
					brne loop22
				dec r21
				brne loop11
			dec r20
			brne loop00
	pop r22
	pop r21
	pop r20
	ret
