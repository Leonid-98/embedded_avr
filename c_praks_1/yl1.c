#include <avr/io.h>

#define TRUE 1

void delay(){
	for (uint32_t i = 1000000; i > 0; i--) {
		}
}


int main(void)
{
	DDRA = 0xFF;
    while (TRUE) 
    {	
		PORTA = 0xFF;
		for (uint32_t i = 1000000; i > 0; i--) {
		}
		
		PORTA = 0;
		for (uint32_t i = 1000000; i > 0; i--) {	
		}
		
    }
}

