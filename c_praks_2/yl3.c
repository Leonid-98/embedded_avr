#include "avr/io.h"
#include "avr/interrupt.h"

#define TRUE 1

ISR(TIMER0_OVF_vect){
	PORTA ^= 0xFF;
	reti();
}

void UARTsendByte(char chr){
	while (!(UCSR1A & 1 << UDRE1));
	UDR1 = chr;
}

void UARTsendString(char *str) {
	char* ptr = str;
	while (*ptr != 0){
		UARTsendByte(*ptr);
		ptr++;
	}
}

int main(void)
{
	// Timer init
	TCCR0A = 0;
	TCCR0B = (1<<CS02) | (0<<CS01) | (1<<CS00); // 1024 prescaler = 101
	TIMSK0 = (1<<TOIE0);					    // overflow interrupt en
	
	// UART init
	UCSR1B = 1<<TXEN1;
	UCSR1C = 1<<UCSZ11 | 1<<UCSZ10; // char size = 8 bit
	UBRR1 = 12;
	
	DDRA = 0xFF;
	PORTA = 0xFF;
	
	sei();
	while (TRUE){
		UARTsendString("Leonid");
	}
}