#include <wiringPi.h>

//used PI pins - wiringPI pins
	unsigned int controlPins[] = {13,10,11,22,21,7,9,8};
	unsigned int inputPins[] = {0,27,16,15,23,26,14,12};
	unsigned int outputPins[] = {6,5,4,3,29,28,24,1};


bool GPIO_direction(int pinNumber, int direction){
	pinMode(pinNumber, direction);
    return true;
}
int GPIO_read(int pinNumber){ return digitalRead(pinNumber); }
bool GPIO_write(int pinNumber, int value){
	digitalWrite(pinNumber, value);
	return true;
}

bool setUpPins(){
	if(wiringPiSetup() == -1){ exit(1); }

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