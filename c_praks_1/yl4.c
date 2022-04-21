#include <avr/io.h>

#define TRUE 1
#define F_CPU 2000000

void delay_1ms(){
	for (uint16_t i = 492; i > 0; i--){
		asm volatile("NOP");
	}
}

void delay_ms(uint16_t ms){
	for (uint16_t i = ms; i > 0; i--){
		delay_1ms();
	}
}


int main(void)
{
	DDRA = 0xFF;
	uint16_t WAIT_TIME = 150;
	
	while (TRUE) {
		for (uint8_t i = 3; i > 0; i--){
			PORTA = 0xFF;
			delay_ms(WAIT_TIME);
			PORTA = 0;
			delay_ms(WAIT_TIME);
			
		}
		delay_ms(WAIT_TIME * 2);
		
		for (uint8_t j = 3; j > 0; j--){
			PORTA = 0xFF;
			delay_ms(WAIT_TIME * 3);
			PORTA = 0;
			delay_ms(WAIT_TIME);
		}
		
		delay_ms(WAIT_TIME * 2);
		
		for (uint8_t j = 3; j > 0; j--){
			PORTA = 0xFF;
			delay_ms(WAIT_TIME);
			PORTA = 0;
			delay_ms(WAIT_TIME);
		}
		
		delay_ms(WAIT_TIME * 7);
	}
}
