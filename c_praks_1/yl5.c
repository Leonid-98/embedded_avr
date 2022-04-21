#include <avr/io.h>

#define TRUE 1
#define F_CPU 2000000

void delay1ms(){
	TIFR0 = 1<<OCF0B;
	TCNT0 = 0;
	OCR0B = 1;
	
	while (!(TIFR0 & (1 << OCF0B)));
	TIFR0 = (1 << OCF0B);
	
}

int main(void)
{
	// JTAG off
	MCUCR |= (1<<JTD);
	MCUCR |= (1<<JTD);
	
	// button
	uint8_t JOY_UP = 1 << PF7;
	uint8_t JOY_DOWN = 1 << PF4;
	DDRF = 0;
	PORTF = JOY_UP | JOY_DOWN;
	
	// led
	DDRA = 0xFF;
	PORTA = 1;
	
	// timer
	TCCR0A = 0;
	TCCR0B = (1<<CS02) | (0<<CS01) | (1<<CS00);
	
	while (TRUE) {
		
		if (!(PINF & JOY_UP)) {
			PORTA >>= 1;
			if (!PORTA) {
				PORTA = 1<<PA7;
			}
			for (uint8_t i = 4; i > 0; i--){
				delay1ms();
			}
			while (!(PINF & JOY_UP));
		}
		
		if (!(PINF & JOY_DOWN)) {
			PORTA <<= 1;
			if (!PORTA) {
				PORTA = 1;
			}
			for (uint8_t i = 4; i > 0; i--){
				delay1ms();
			}
			while (!(PINF & JOY_DOWN));
		}
		
		
		
		
	}
}
