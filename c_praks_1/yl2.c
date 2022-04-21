#include <avr/io.h>

#define TRUE 1

void delay_500(){
	for (uint16_t i = 0xFFFF; i > 0; i--){
		asm volatile("NOP");
	}
}


int main(void)
{
	DDRA = 0xFF;
	while (TRUE)
	{
		for (uint8_t i = 3; i > 0; i--){
			PORTA = 0xFF;
			delay_500();
			PORTA = 0;
			delay_500();
			
		}
		delay_500();
		delay_500();
		
		for (uint8_t j = 3; j > 0; j--){
			PORTA = 0xFF;
			delay_500();
			delay_500();
			delay_500();
			PORTA = 0;
			delay_500();
		}
		
		delay_500();
		delay_500();
		
		for (uint8_t j = 3; j > 0; j--){
			PORTA = 0xFF;
			delay_500();
			PORTA = 0;
			delay_500();
		}
		
		for (uint8_t j = 6; j > 0; j--){
			delay_500();
		}
	}
}
