#define BCM2708_PERI_BASE        0x3F000000
#define GPIO_BASE                (BCM2708_PERI_BASE + 0x200000) /* GPIO controller */
 
 
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
 
#define PAGE_SIZE (4*1024)
#define BLOCK_SIZE (4*1024)
 
int  mem_fd;
void *gpio_map;
 
// I/O access
volatile unsigned *gpio;
 
// GPIO setup macros. Always use INP_GPIO(x) before using OUT_GPIO(x) or SET_GPIO_ALT(x,y)
#define INP_GPIO(g) *(gpio+((g)/10)) &= ~(7<<(((g)%10)*3))
#define OUT_GPIO(g) *(gpio+((g)/10)) |=  (1<<(((g)%10)*3))
#define SET_GPIO_ALT(g,a) *(gpio+(((g)/10))) |= (((a)<=3?(a)+4:(a)==4?3:2)<<(((g)%10)*3))
 
#define GPIO_SET *(gpio+7)  // sets   bits which are 1 ignores bits which are 0
#define GPIO_CLR *(gpio+10) // clears bits which are 1 ignores bits which are 0
 
#define GET_GPIO(g) (*(gpio+13)&(1<<g)) // 0 if LOW, (1<<g) if HIGH
 
#define GPIO_PULL *(gpio+37) // Pull up/pull down
#define GPIO_PULLCLK0 *(gpio+38) // Pull up/pull down clock

void setup_io(){
   /* open /dev/mem */
   if ((mem_fd = open("/dev/mem", O_RDWR|O_SYNC) ) < 0) {
      printf("can't open /dev/mem \n");
      exit(-1);
   }
 
   /* mmap GPIO */
   gpio_map = mmap(
      NULL,             //Any adddress in our space will do
      BLOCK_SIZE,       //Map length
      PROT_READ|PROT_WRITE,// Enable reading & writting to mapped memory
      MAP_SHARED,       //Shared with other processes
      mem_fd,           //File to map
      GPIO_BASE         //Offset to GPIO peripheral
   );
 
   close(mem_fd); //No need to keep mem_fd open after mmap
 
   if (gpio_map == MAP_FAILED) {
      printf("mmap error %d\n", (int)gpio_map);//errno also set!
      exit(-1);
   }
 
   // Always use volatile pointer!
   gpio = (volatile unsigned *)gpio_map;
}





//used PI pins - wiringPI pins
	unsigned int controlPins[] = {9,8,7,6,5,4,3,2};
	unsigned int inputPins[] = {17,16,15,14,13,12,11,10};
	unsigned int outputPins[] = {25,24,23,22,21,20,19,18};

bool GPIO_direction(int pinNumber, int direction){ 
    INP_GPIO(pinNumber);
    if(direction != 0 ){ OUT_GPIO(pinNumber); }
    return true; 
}
int GPIO_read(int pinNumber){ 
  if(GET_GPIO(pinNumber)){ return 1; }
  else{ return 0; }
}
bool GPIO_write(int pinNumber, int value){
    if(value != 0){ GPIO_SET = 1<<pinNumber; }
    else{ GPIO_CLR = 1<<pinNumber; }
    return true; 
}

bool setUpPins(){
    setup_io();

	//set direction of control pins
		for(unsigned int a = 0; a < (sizeof(controlPins)/sizeof(*controlPins)); a++){
			if( !GPIO_direction(controlPins[a],1) ){ std::cout << "- error: could not set direction of control pin: " << a << std::endl; return false; }
		}
	//set direction of input pins
		for(unsigned int a = 0; a < (sizeof(inputPins)/sizeof(*inputPins)); a++){
			if( !GPIO_direction(inputPins[a],1) ){ std::cout << "- error: could not set direction of input pin: " << a << std::endl; return false; }
		}
	//set direction of output pins
		for(unsigned int a = 0; a < (sizeof(outputPins)/sizeof(*outputPins)); a++){
			if( !GPIO_direction(outputPins[a],0) ){ std::cout << "- error: could not set direction of output pin: " << a << std::endl; return false; }
		}
		
	return true;
}

bool shutDownPins(){ return true; }