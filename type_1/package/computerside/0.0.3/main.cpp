#include <sys/stat.h>
#include <sys/types.h>
#include <iostream>
#include <string>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define IN  0
#define OUT 1
 
#define LOW  0
#define HIGH 1

bool GPIO_export(int pinNumber){
    #define BUFFER_MAX 3

	char buffer[BUFFER_MAX];
	ssize_t bytes_written;
	int fd;
 
	fd = open("/sys/class/gpio/export", O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "GPIO_export::Failed to export pin\n");
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
		fprintf(stderr, "GPIO_unexport::Failed to unexport pin\n");
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
		fprintf(stderr, "GPIO_direction::GPIO direction access failure\n");
		return false;
	}
 
	if (-1 == write(fd, &s_directions_str[IN == direction ? 0 : 3], IN == direction ? 2 : 3)) {
		fprintf(stderr, "GPIO_direction::Failed to set direction\n");
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
		fprintf(stderr, "GPIO_read::Failed to open gpio value for reading!\n");
		return(-1);
	}
 
	if (-1 == read(fd, value_str, 3)) {
		fprintf(stderr, "GPIO_read::Failed to read value!\n");
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
		fprintf(stderr, "GPIO_write::Failed to open gpio value for writing!\n");
		return false;
	}
 
	if (1 != write(fd, &s_values_str[LOW == value ? 0 : 1], 1)) {
		fprintf(stderr, "GPIO_write::Failed to write value!\n");
		return false;
	}
 
	close(fd);
	return true;
}

bool GPIO_API_writeByte(int port, int bit7, int bit6, int bit5, int bit4, int bit3, int bit2, int bit1, int bit0){
    switch(port){
        case 0: //| 2  3  4  5  6  7  8  9  |
            if( !GPIO_write(9,bit7) ||
                !GPIO_write(8,bit6) ||
                !GPIO_write(7,bit5) ||
                !GPIO_write(6,bit4) ||
                !GPIO_write(5,bit3) ||
                !GPIO_write(4,bit2) ||
                !GPIO_write(3,bit1) ||
                !GPIO_write(2,bit0) ){ std::cout << "GPIO_API_writeByte:: could not write control byte" << std::endl; return false; }
        break;
        case 1: // | 10 11 12 13 14 15 16 17 |
            if( !GPIO_write(17,bit7) ||
                !GPIO_write(16,bit6) ||
                !GPIO_write(15,bit5) ||
                !GPIO_write(14,bit4) ||
                !GPIO_write(13,bit3) ||
                !GPIO_write(12,bit2) ||
                !GPIO_write(11,bit1) ||
                !GPIO_write(10,bit0) ){ std::cout << "GPIO_API_writeByte:: could not write input byte" << std::endl; return false; }
        break;
        default: std::cout << "GPIO_API_writeByte:: could not write byte. Bad port number" << std::endl; return false; break;
    }

    return true;
}

std::string bitToChar(int bit){
    if(bit){return "1";}else{return "0";}
}


std::string GPIO_API_readByte(){
    return  "" + bitToChar( GPIO_read(25) ) + 
            bitToChar( GPIO_read(24) ) + 
            bitToChar( GPIO_read(23) ) + 
            bitToChar( GPIO_read(22) ) + 
            bitToChar( GPIO_read(21) ) + 
            bitToChar( GPIO_read(20) ) + 
            bitToChar( GPIO_read(19) ) + 
            bitToChar( GPIO_read(18) );
}





int main(int argc, char *argv[]){
    //export and set direction of control pins
        // | 2  3  4  5  6  7  8  9  |
        if( !GPIO_export(2) ||
            !GPIO_export(3) ||
            !GPIO_export(4) ||
            !GPIO_export(5) ||
            !GPIO_export(6) ||
            !GPIO_export(7) ||
            !GPIO_export(8) ||
            !GPIO_export(9)
        ){ std::cout << "could not export control pins" << std::endl; return 0; }
        if( !GPIO_direction(2,OUT) ||
            !GPIO_direction(3,OUT) ||
            !GPIO_direction(4,OUT) ||
            !GPIO_direction(5,OUT) ||
            !GPIO_direction(6,OUT) ||
            !GPIO_direction(7,OUT) ||
            !GPIO_direction(8,OUT) ||
            !GPIO_direction(9,OUT)
        ){ std::cout << "could not set direction of control pins" << std::endl; return 0; }

    //export and set direction of input pins
        // | 10 11 12 13 14 15 16 17 |
        if( !GPIO_export(10) ||
            !GPIO_export(11) ||
            !GPIO_export(12) ||
            !GPIO_export(13) ||
            !GPIO_export(14) ||
            !GPIO_export(15) ||
            !GPIO_export(16) ||
            !GPIO_export(17)
        ){ std::cout << "could not export input pins" << std::endl; return 0; }
        if( !GPIO_direction(10,OUT) ||
            !GPIO_direction(11,OUT) ||
            !GPIO_direction(12,OUT) ||
            !GPIO_direction(13,OUT) ||
            !GPIO_direction(14,OUT) ||
            !GPIO_direction(15,OUT) ||
            !GPIO_direction(16,OUT) ||
            !GPIO_direction(17,OUT)
        ){ std::cout << "could not set direction of input pins" << std::endl; return 0; }

    //export and set direction of output pins
        // | 18 19 20 21 22 23 24 25 |
        if( !GPIO_export(18) ||
            !GPIO_export(19) ||
            !GPIO_export(20) ||
            !GPIO_export(21) ||
            !GPIO_export(22) ||
            !GPIO_export(23) ||
            !GPIO_export(24) ||
            !GPIO_export(25)
        ){ std::cout << "could not export output pins" << std::endl; return 0; }
        if( !GPIO_direction(18,IN) ||
            !GPIO_direction(19,IN) ||
            !GPIO_direction(20,IN) ||
            !GPIO_direction(21,IN) ||
            !GPIO_direction(22,IN) ||
            !GPIO_direction(23,IN) ||
            !GPIO_direction(24,IN) ||
            !GPIO_direction(25,IN)
        ){ std::cout << "could not set direction of output pins" << std::endl; return 0; }


        //fill messageIn with data
            GPIO_API_writeByte(0, 0,1,0,0,0,0,0,1); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,0,0,1,0); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,0,0,1,1); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,0,1,0,0); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,0,1,0,1); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,0,1,1,0); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,0,1,1,1); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,1,0,0,1); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,1,0,1,0); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,1,0,1,1); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,1,1,0,0); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,1,1,0,1); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,1,1,1,0); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,0,1,1,1,1); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);
            GPIO_API_writeByte(0, 0,1,0,1,0,0,0,0); GPIO_API_writeByte(1, 0,0,0,0,1,1,1,1); usleep(1000);

            usleep(1000 * 1000);

        //read outputs
            GPIO_API_writeByte(0, 0,0,0,0,0,0,0,1); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,0,0,1,0); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,0,0,1,1); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,0,1,0,0); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,0,1,0,1); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,0,1,1,0); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,0,1,1,1); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,1,0,0,1); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,1,0,1,0); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,1,0,1,1); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,1,1,0,0); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,1,1,0,1); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,1,1,1,0); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,0,1,1,1,1); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);
            GPIO_API_writeByte(0, 0,0,0,1,0,0,0,0); std::cout << GPIO_API_readByte() << std::endl; usleep(1000);   


    //disconnect 
        if( !GPIO_unexport(2) ||
            !GPIO_unexport(3) ||
            !GPIO_unexport(4) ||
            !GPIO_unexport(5) ||
            !GPIO_unexport(6) ||
            !GPIO_unexport(7) ||
            !GPIO_unexport(8) ||
            !GPIO_unexport(9)
        ){ std::cout << "could not unexport control pins" << std::endl; return 0; }
        if( !GPIO_unexport(10) ||
            !GPIO_unexport(11) ||
            !GPIO_unexport(12) ||
            !GPIO_unexport(13) ||
            !GPIO_unexport(14) ||
            !GPIO_unexport(15) ||
            !GPIO_unexport(16) ||
            !GPIO_unexport(17)
        ){ std::cout << "could not unexport input pins" << std::endl; return 0; }
        if( !GPIO_unexport(18) ||
            !GPIO_unexport(19) ||
            !GPIO_unexport(20) ||
            !GPIO_unexport(21) ||
            !GPIO_unexport(22) ||
            !GPIO_unexport(23) ||
            !GPIO_unexport(24) ||
            !GPIO_unexport(25)
        ){ std::cout << "could not unexport output pins" << std::endl; return 0; }
    return 0;
}