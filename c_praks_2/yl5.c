#include "avr/io.h"
#include "avr/interrupt.h"
#define TRUE 1

uint8_t counter_flip = 0;
uint8_t counter_right = 0;
uint8_t counter_left = 0;
uint8_t numbers[10] = {
	0b11111100,
	0b01100000,
	0b11011010,
	0b11110010,
	0b01100110,
	0b10110110,
	0b10111110,
	0b11100000,
	0b11111110,
	0b11110110
};

void shiftByteOut(uint8_t number){
	for (uint8_t i = 8; i > 0; i--){
		if (number & 1){
			PORTE = 1<<PE4;
			PORTE = (1<<PE4) | (1<<PE3);
			} else {
			PORTE = 0<<PE4;
			PORTE = (0<<PE4) | (1<<PE3);
		}
		number >>= 1;
	}
	PORTB = 1<<PB7;
	PORTB = 0;
}

ISR(TIMER0_OVF_vect){
	// fast timer
	counter_flip ^= 0xFF;
	if (counter_flip){
		PORTD = 1<<PD4;
		shiftByteOut(numbers[counter_right]);
		} else {
		PORTD = 0;
		shiftByteOut(numbers[counter_left]);
	}
}

ISR(TIMER1_COMPA_vect){
	// slow timer
	counter_right++;
	if (counter_right == 10){
		counter_right = 0;
		counter_left++;
	}
	if (counter_left == 10)
	counter_left = 0;
}


int main(void){
	// slow timer init
	TCCR1A = (1<<WGM10) | (0<<WGM11);
	TCCR1B = (0<<WGM12) | (1<<WGM13) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	TIMSK1 = 1<<OCIE1A;  // interrupt en
	OCR1A = 128; // blink delay
	
	// fast timer
	TCCR0A = 0;
	TCCR0B = (0<<CS02) | (1<<CS01) | (1<<CS00);
	TIMSK0 = (1<<TOIE0); // overflow interrupt en
	
	// 7 segment init
	DDRE = (1<<PE4) | (1<<PE3); // DS and SHCP
	PORTE = 0;
	DDRB = 1<<PB7;
	PORTB = 1<<PB7;
	DDRD = 1<<PD4;
	
	DDRA = 0xFF;
	PORTA = 0xFF;
	
	sei();
	while (TRUE);
}