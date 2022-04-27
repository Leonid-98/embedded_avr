#include "avr/io.h"
#include "avr/interrupt.h"
#define TRUE 1


ISR(TIMER1_COMPA_vect){
	// compare with OCR1A
	PORTA ^= 0xFF;
	reti();
}

ISR(USART0_RX_vect){
	DDRA = 0xFF;
	switch (UDR1){
		case '0':
			PORTA = 0;
			DDRA = 0;
			break;
		case '1':
			OCR1A = 976;
			break;
		case '2':
			OCR1A = 488;
			break;
		case '3':
			OCR1A = 325;
			break;
		case '4':
			OCR1A = 244;
			break;
		case '5':
			OCR1A = 195;
			break;
		case '6':
			OCR1A = 162;
			break;
		case '7':
			OCR1A = 139;
			break;
		case '8':
			OCR1A = 122;
			break;
		case '9':
			OCR1A = 108;
			break;
		case 'X':
			OCR1A = 1;
			break;
	}
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

int main(void){
	// Timer init (PWM, phase and frequency Correct), 1024 prescaler
	TCCR1A = (1<<WGM10) | (0<<WGM11);
	TCCR1B = (0<<WGM12) | (1<<WGM13) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	TIMSK1 = 1<<OCIE1A ; // interrupt en
	
	// USART init
	UCSR1B = 1<<TXEN1 | 1<<RXEN1 | 1<<RXCIE1; // RX interrupt en
	UCSR1C = 1<<UCSZ11 | 1<<UCSZ10; // char size = 8 bit
	UBRR1 = 12;
	
	//led
	DDRA = 0xFF;
	PORTA = 0xFF;
	
	sei();
	while (TRUE){
		UARTsendString("Leonid");
	}
}