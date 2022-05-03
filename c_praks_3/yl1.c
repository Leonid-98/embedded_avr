#include "avr/io.h"
#include "avr/interrupt.h"
#include "notes.h"
#include "song1.h"
#include "song2.h"

ISR(TIMER1_COMPA_vect){
	// prescaler 1024
	PORTB ^= 1<<PB7;
	PORTA ^= 0xFF;
}

uint16_t calculateTimerDelay(uint16_t delayMs) {
	// https://moodle.ut.ee/pluginfile.php/189029/mod_resource/content/12/ASM%203%20praktikum.pdf
	return (delayMs - delayMs/32 + delayMs/128)*2048/2000;
}

int main(void){
	// TIMER1 init (WGM = PWM, phase and freq correct)
	TCCR1A = (1<<WGM10) | (0<<WGM11);
	TCCR1B = (0<<WGM12) | (1<<WGM13) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	TIMSK1 = 1<<OCIE1A;  // interrupt en
	OCR1A = calculateTimerDelay(500); // blink delay, 16bit max
	
	// buzzer init
	DDRB = 0xFF;
	PORTB |= 1<<PB7;
	
	// led debug
	DDRA = 0xFF;
	PORTA = 0xFF;
	
	sei();
	while (1);
}

