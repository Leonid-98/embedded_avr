#include <avr/io.h>
#define TRUE 1

int main(void)
{
	// timer1, clear on compare, set at top
	TCCR1A = (1<<WGM11) | (1<<WGM10) | (1<<COM1A1);
	TCCR1B = (1<<WGM12) | (1<<CS10);
	
	// timer led
	DDRB = (1<<PB5);
	
	// ADC
	ADMUX = (1<<REFS0) | (1<<MUX1);  //reference = VCC
	ADCSRA = (1<<ADEN) | (1<<ADSC) | (1<<ADATE); //ADCENable, ADcStartConversion, ADcAutoTriggerEnable
	
	DDRA = 0xFF;
	
	while (TRUE){
		// wait for ADC
		while (!(ADCSRA & (1<<ADIF)));
		
		PORTA = ADC;
		OCR1A = ADC;
	}
}

