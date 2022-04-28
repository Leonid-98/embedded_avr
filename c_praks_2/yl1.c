#include <avr/io.h>

#define TRUE 1
#define BAUD_RATE 9600
#define F_CPU 2000000
#define SAMPLES 16

void sendNumber(uint8_t number){
	// wait for USART Data Register Empty
	while (!(UCSR1A & 1 << UDRE1));
	UDR1 = '0' + number;
}

int main(void)
{
	// UART
	UCSR1B = (1 << TXEN1); //TX
	UCSR1C = (1 << UCSZ11) | (1 << UCSZ10); // 8bit
	UBRR1 = 12; // F_CPU / (BAUD_RATE * SAMPLES) - 1;
	
	// ADC
	ADMUX = (1 << REFS0) | (1 << MUX1);
	ADCSRA = (1 << ADEN) | (1 << ADSC) | (1 << ADATE);
	
	DDRA = 0xFF;
	
	while (TRUE){
		// wait for ADC
		while (!(ADCSRA & 1 << ADIF));
		//PORTA = ADC; porta8bit, adc 16bit
		uint16_t adcDec = ADC / 100;
		PORTA = adcDec;
		if (adcDec > 9){
			adcDec = 9;
		}
		sendNumber(adcDec);
	}
	
	
}

