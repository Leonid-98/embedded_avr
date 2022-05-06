#include "avr/io.h"
#include "avr/interrupt.h"
#include "notes.h"
#include "song1.h"
#include "song2.h"

#define F_CPU 2000000

volatile uint16_t i = 0;
const uint16_t lenMelody1 = sizeof(melody1) / sizeof(melody1[0]);


uint16_t scaleDelay(uint16_t delayMs) {
	return (delayMs - delayMs/32 + delayMs/128);
}

uint16_t freqToDelay(uint16_t freq) {
	return F_CPU/freq/2;
}

int16_t myAbs(int16_t v) {
	return v * ((v>0) - (v<0));
}


ISR(TIMER1_COMPA_vect){
	// fast timer, freq generator
	PINB = 1<<PB6;
}


ISR(TIMER3_COMPA_vect){
	// slow timer, tone changer
	TCNT3 = 0;
	i += 2;
	if (i > lenMelody1)
	i = 0;
}


int main(void){
	// TIMER1, sound generator, fast timer
	TCCR1A = (1<<WGM10) | (1<<WGM11);
	TCCR1B = (1<<WGM12) | (1<<WGM13) | (1<<CS10);
	TIMSK1 = 1<<OCIE1A;  // interrupt en
	
	// TIMER3, tone changer, slow timer
	TCCR3A = (0<<WGM30) | (0<<WGM31);
	TCCR3B = (0<<WGM32) | (0<<WGM33) | (1<<CS32) | (0<<CS31) | (1<<CS30);
	TIMSK3 = 1<<OCIE3A;  // interrupt en
	
	// buzzer init
	DDRB = 0xFF;
	PORTB |= 1<<PB6;
	
	// led debug
	DDRA = 0xFF;
	PORTA = 0xFF;
	
	sei();
	
	while (1) {
		// freq selector
		if (melody1[i]) {
			TIMSK1 |= 1<<OCIE1A;
			OCR1A = freqToDelay(melody1[i]);
			} else {
			TIMSK1 |= 0<<OCIE1A;
		}
		
		// note selector
		int16_t lenNote1 = (240000/tempo1) / myAbs(melody1[i+1]) * 2;
		if (melody1[i+1] < 0)
		lenNote1 *= 1.5;
		OCR3A = scaleDelay(lenNote1);
	}
}

