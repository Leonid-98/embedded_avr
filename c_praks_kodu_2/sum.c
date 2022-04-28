#include "avr/io.h"
#include "avr/interrupt.h"


int32_t getSum(uint8_t *data, uint16_t count){
	uint32_t sum = 0;
	for (uint8_t i = 0; i < count; i++){
		sum += data[i];
	}
	return sum;
}

uint8_t strcpy1(char *dest, char *src, uint16_t destSize){
	// length control
	uint16_t count = 0;
	while (src[count] != '\0')
	count++;
	if (count > destSize)
	return 0;
	
	// copy
	uint16_t i = 0;
	while (i < count){
		dest[i] = src[i];
		i++;
	}
	dest[i] = '\0';
	return 1;
}

uint8_t concatenate(char *dest, char *src, uint16_t destSize) {
	destSize -= 1;
	// len control
	uint16_t srcCnt = 0;
	while (src[srcCnt] != '\0'){
		srcCnt++;
	}
	uint16_t destCnt = 0;
	while (dest[destCnt] != '\0'){
		destCnt++;
	}
	
	uint16_t freeSpace = destSize - destCnt;
	uint16_t freeCnt = 0;
	uint8_t isFit;
	if (freeSpace >= srcCnt){
		isFit = 1;
		} else {
		isFit = 0;
	}
	
	while (freeCnt <= freeSpace) {
		dest[destCnt] = src[freeCnt];
		destCnt++;
		freeCnt++;
	}
	dest[destCnt] = '\0';
	
	return isFit;
	
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
	UCSR1B = 1<<TXEN1;
	UCSR1C = 1<<UCSZ11 | 1<<UCSZ10; // char size = 8 bit
	UBRR1 = 12;
	
	DDRA = 0xFF;
	PORTA = 0xFF;
	
	// yl1 copy
	//char dest1[8];
	//char src1[8] = "Leonid;";
	//PORTA = strcpy1(dest1, src1, 8);
	//UARTsendString(dest1);
	
	// yl2 concatenate
	
	char dest[4] = {'1','2','3',0};
	char src[] = {'a','b',0};
	PORTA = concatenate(dest, src, 3);
	UARTsendString(dest);
	//
	//#define ARRAY_SIZE 4
	//uint16_t count = ARRAY_SIZE;
	//uint8_t data[ARRAY_SIZE] = {1, 2, 3, 4};
	//uint8_t sum = getSum(data, count);
	//UARTsendByte(sum);
	
	while(1);
}
