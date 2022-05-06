#include "avr/io.h"

int32_t getSum(uint8_t *data, uint16_t count){
	uint32_t sum = 0;
	for (uint8_t i = 0; i < count; i++){
		sum += data[i];
	}
	return sum;
}

int32_t getMinRegion(int8_t *array, uint16_t count, uint16_t *start, uint16_t *end){
	const uint16_t size = count;
	uint8_t *ptr = array;
	
	int32_t minSum = INT32_MAX;
	int32_t tempSum;
	
	for (uint16_t startCnt = 0; startCnt < size - 1; startCnt++) {
		for (uint8_t endCnt = count; endCnt > 1; endCnt--){
			tempSum = getSum(ptr, count);
			if (tempSum < minSum) {
				minSum = tempSum;
				*start = startCnt;
				*end = endCnt;
			}
		}
		ptr++;
		count--;
	}
	return minSum;
}

int main(void){
	int8_t array[3] = {10, -1, 2};
	uint16_t start = 0;
	uint16_t end = 0;
	
	int32_t minSum = getMinRegion(array, 3, *start, *end);
	
	
	
	while (1);
}
