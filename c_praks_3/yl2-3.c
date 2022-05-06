#include "avr/io.h"
#include "avr/interrupt.h"
#include "notes.h"
#include "song1.h"
#include "song2.h"
#include "song3.h"

#define F_CPU 2000000

volatile uint16_t i = 0;
int16_t* melodies[3];
int16_t tempos[3];

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
}

void delay1ms(){
	TIFR0 = 1<<OCF0B;
	TCNT0 = 0;
	OCR0B = 1;
	
	while (!(TIFR0 & (1 << OCF0B)));
	TIFR0 = (1 << OCF0B);
}


int main(void){
	int16_t* melodies[] = {melody1, melody2, melody3};
	int16_t tempos[] = {tempo1, tempo2, tempo3};
	

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
	
	// button init
	MCUCR |= (1<<JTD);
	MCUCR |= (1<<JTD);
	uint8_t JOY_UP = 1 << PF7;
	uint8_t JOY_DOWN = 1 << PF4;
	DDRF = 0;
	PORTF = JOY_UP | JOY_DOWN;
	// button timer
	TCCR0A = 0;
	TCCR0B = (1<<CS02) | (0<<CS01) | (1<<CS00);
	
	uint8_t melodySel = 2;
	
	sei();
	while (1) {
		// button up
		if (!(PINF & JOY_UP)) {
			i=0;
			melodySel++;
			if (melodySel > 2) {
				melodySel = 0;
			}
			
			// bouncy time
			for (uint8_t i = 4; i > 0; i--){
				delay1ms();
			}
			while (!(PINF & JOY_UP));
		}
		
		// melody selector
		PORTA = melodySel;
		int16_t* melody = melodies[melodySel];
		int16_t tempo = tempos[melodySel];
		
		// freq selector
		if (melody[i]) {
			TIMSK1 = 1<<OCIE1A;
			OCR1A = freqToDelay(melody[i]);
			} else {
			TIMSK1 = 0<<OCIE1A;
		}

		// note selector
		int16_t lenNote = (240000/tempo) / myAbs(melody[i+1]) * 2;
		if (melody[i+1] < 0)
		lenNote *= 1.5;
		OCR3A = scaleDelay(lenNote);
	}
}

