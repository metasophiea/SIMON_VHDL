//used PI pins
	// unsigned int controlPins[] = {9,8,7,6,5,4,3,2};
	// unsigned int inputPins[] = {17,16,15,14,13,12,11,10};
	// unsigned int outputPins[] = {25,24,23,22,21,20,19,18};
	//wiringPI pins
	unsigned int controlPins[] = {13,10,11,22,21,7,9,8};
	unsigned int inputPins[] = {0,27,16,15,23,26,14,12};
	unsigned int outputPins[] = {6,5,4,3,29,28,24,1};


#define IN  0
#define OUT 1

bool GPIO_export(int pinNumber){ return true; }
bool GPIO_unexport(int pinNumber){ return true; }

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

//export and set direction of control pins
	for(unsigned int a = 0; a < (sizeof(controlPins)/sizeof(*controlPins)); a++){
		if( !GPIO_export(controlPins[a]) ){std::cout << "- error: could not export control pin: " << a << std::endl; return false;}
		if( !GPIO_direction(controlPins[a],OUT) ){ std::cout << "- error: could not set direction of control pin: " << a << std::endl; return false; }
	}
//export and set direction of input pins
	for(unsigned int a = 0; a < (sizeof(inputPins)/sizeof(*inputPins)); a++){
		if( !GPIO_export(inputPins[a]) ){std::cout << "- error: could not export input pin: " << a << std::endl; return false;}
		if( !GPIO_direction(inputPins[a],OUT) ){ std::cout << "- error: could not set direction of input pin: " << a << std::endl; return false; }
	}
//export and set direction of output pins
	for(unsigned int a = 0; a < (sizeof(outputPins)/sizeof(*outputPins)); a++){
		if( !GPIO_export(outputPins[a]) ){std::cout << "- error: could not export output pin: " << a << std::endl; return false;}
		if( !GPIO_direction(outputPins[a],IN) ){ std::cout << "- error: could not set direction of output pin: " << a << std::endl; return false; }
	}
	
return true;
}

bool shutDownPins(){
	//unexport control pins
		for(unsigned int a = 0; a < (sizeof(controlPins)/sizeof(*controlPins)); a++){
			if( !GPIO_unexport(controlPins[a]) ){std::cout << "- error: could not unexport control pin: " << a << std::endl; return false;}
		}
    //unexport input pins
		for(unsigned int a = 0; a < (sizeof(inputPins)/sizeof(*inputPins)); a++){
			if( !GPIO_unexport(inputPins[a]) ){std::cout << "- error: could not unexport input pin: " << a << std::endl; return false;}
		}
    //unexport output pins
		for(unsigned int a = 0; a < (sizeof(outputPins)/sizeof(*outputPins)); a++){
			if( !GPIO_unexport(outputPins[a]) ){std::cout << "- error: could not unexport output pin: " << a << std::endl; return false;}
		}
		
	return true;	
}