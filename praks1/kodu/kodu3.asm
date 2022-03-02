ldi r16, 0
ldi r17, 0xFF
out 0x01, r17 // DDRA

main:
	com r16
	out 0x02, r16 // PORTA
	ldi r20, 33
	loop0:
		ldi r21, 100
		loop1:
			ldi r22, 100 
			loop2:
				dec r22
				brne loop2
			dec r21
			brne loop1
		dec r20
		brne loop0
rjmp main
