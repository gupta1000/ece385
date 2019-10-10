// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main(){
	short p = 0;

	volatile unsigned int* LED_PIO = (unsigned int*) 0x40;
	volatile unsigned int* SW_PIO = (unsigned int*) 0x00;
	volatile unsigned int* KEY_PIO = (unsigned int*) 0x00;

	unsigned int accumulator = 0;
	while (1){
		if(*KEY_PIO == 0x2)
			*LED_PIO = 0;
		else if(*KEY_PIO == 0x1 && p == 0){
			*LED_PIO += *SW_PIO;
			p = 1;
		}
		if(*KEY_PIO != 0x1) p = 0;
	}
	return -1;

//	int i = 0;
//	volatile unsigned int *LED_PIO = (unsigned int*)0x40;
//	*LED_PIO = 0;
//	while(1){
//		for(i=0; i < 100000; i++) *LED_PIO |= 0x1;
//		for(i=0; i < 100000; i++) *LED_PIO &= ~0x1;
//	}
//	return 1;
}
