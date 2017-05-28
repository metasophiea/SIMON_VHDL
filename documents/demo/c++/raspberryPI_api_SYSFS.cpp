//used PI pins
	unsigned int controlPins[] = {9,8,7,6,5,4,3,2};
	unsigned int inputPins[] = {17,16,15,14,13,12,11,10};
	unsigned int outputPins[] = {25,24,23,22,21,20,19,18};

#define IN  0
#define OUT 1
	
#define LOW  0
#define HIGH 1

//dev function
//	bool GPIO_export(int pinNumber){/*std::cout << "exporting pin: " << pinNumber << std::endl;*/ return true;}
//	bool GPIO_unexport(int pinNumber){/*std::cout << "unexporting pin: " << pinNumber << std::endl;*/ return true;}
//	bool GPIO_direction(int pinNumber, int direction){/*std::cout << "setting pin direction: " << pinNumber << " to " << direction << std::endl;*/ return true;}
//	static int GPIO_read(int pinNumber){/*std::cout << "reading pin: " << pinNumber << std::endl;*/ return 0;}
//	bool GPIO_write(int pinNumber, int value){/*std::cout << "writing " << value << " to pin " << pinNumber << std::endl;*/ return true;}

#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

bool GPIO_export(int pinNumber){
	#define BUFFER_MAX 3

	char buffer[BUFFER_MAX];
	ssize_t bytes_written;
	int fd;
	
	fd = open("/sys/class/gpio/export", O_WRONLY);
	if (-1 == fd) {
		std::cout << "- error:GPIO_export:Failed to export pin" << std::endl;
		return false;
	}
	
	bytes_written = snprintf(buffer, BUFFER_MAX, "%d", pinNumber);
	write(fd, buffer, bytes_written);
	close(fd);
	return true;
}

bool GPIO_unexport(int pinNumber){
	char buffer[BUFFER_MAX];
	ssize_t bytes_written;
	int fd;
	
	fd = open("/sys/class/gpio/unexport", O_WRONLY);
	if (-1 == fd) {
		std::cout << "- error:GPIO_unexport:Failed to unexport pin" << std::endl;
		return false;
	}
	
	bytes_written = snprintf(buffer, BUFFER_MAX, "%d", pinNumber);
	write(fd, buffer, bytes_written);
	close(fd);
	return true;
}

bool GPIO_direction(int pinNumber, int direction){
	static const char s_directions_str[]  = "in\0out";
	
	#define DIRECTION_MAX 35
	char path[DIRECTION_MAX];
	int fd;
	
	snprintf(path, DIRECTION_MAX, "/sys/class/gpio/gpio%d/direction", pinNumber);
	fd = open(path, O_WRONLY);
	if (-1 == fd) {
		std::cout << "- error:GPIO_direction:GPIO direction access failure" << std::endl;
		return false;
	}
	
	if (-1 == write(fd, &s_directions_str[IN == direction ? 0 : 3], IN == direction ? 2 : 3)) {
		std::cout << "- error:GPIO_direction:Failed to set direction" << std::endl;
		return false;
	}
	
	close(fd);
	return true;
}

static int GPIO_read(int pinNumber){
	#define VALUE_MAX 30
	char path[VALUE_MAX];
	char value_str[3];
	int fd;
	
	snprintf(path, VALUE_MAX, "/sys/class/gpio/gpio%d/value", pinNumber);
	fd = open(path, O_RDONLY);
	if (-1 == fd) {
		std::cout << "- error:GPIO_read:Failed to open gpio value for reading" << std::endl;
		return(-1);
	}
	
	if (-1 == read(fd, value_str, 3)) {
		std::cout << "- error:GPIO_read:Failed to read value" << std::endl;
		return(-1);
	}
	
	close(fd);
	return(atoi(value_str));
}

bool GPIO_write(int pinNumber, int value){
	static const char s_values_str[] = "01";
	
	char path[VALUE_MAX];
	int fd;
	
	snprintf(path, VALUE_MAX, "/sys/class/gpio/gpio%d/value", pinNumber);
	fd = open(path, O_WRONLY);
	if (-1 == fd) {
		std::cout << "- error:GPIO_write:Failed to open gpio value for writing" << std::endl;
		return false;
	}
	
	if (1 != write(fd, &s_values_str[LOW == value ? 0 : 1], 1)) {
		std::cout << "- error:GPIO_write:Failed to write value" << std::endl;
		return false;
	}
	
	close(fd);
	return true;
}

bool setUpPins(){
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