#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define IN  0
#define OUT 1
 
#define LOW  0
#define HIGH 1

static int GPIO_export(int pinNumber){
    #define BUFFER_MAX 3

	char buffer[BUFFER_MAX];
	ssize_t bytes_written;
	int fd;
 
	fd = open("/sys/class/gpio/export", O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "Failed to export pin\n");
		return(-1);
	}
 
	bytes_written = snprintf(buffer, BUFFER_MAX, "%d", pinNumber);
	write(fd, buffer, bytes_written);
	close(fd);
	return(0);
}

static int GPIO_unexport(int pinNumber){
	char buffer[BUFFER_MAX];
	ssize_t bytes_written;
	int fd;
 
	fd = open("/sys/class/gpio/unexport", O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "Failed to unexport pin\n");
		return(-1);
	}
 
	bytes_written = snprintf(buffer, BUFFER_MAX, "%d", pinNumber);
	write(fd, buffer, bytes_written);
	close(fd);
	return(0);
}

static int GPIO_direction(int pinNumber, int direction){
	static const char s_directions_str[]  = "in\0out";
 
    #define DIRECTION_MAX 35
	char path[DIRECTION_MAX];
	int fd;
 
	snprintf(path, DIRECTION_MAX, "/sys/class/gpio/gpio%d/direction", pinNumber);
	fd = open(path, O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "GPIO direction access failure\n");
		return(-1);
	}
 
	if (-1 == write(fd, &s_directions_str[IN == direction ? 0 : 3], IN == direction ? 2 : 3)) {
		fprintf(stderr, "Failed to set direction\n");
		return(-1);
	}
 
	close(fd);
	return(0);
}

static int GPIO_read(int pinNumber)
{
#define VALUE_MAX 30
	char path[VALUE_MAX];
	char value_str[3];
	int fd;
 
	snprintf(path, VALUE_MAX, "/sys/class/gpio/gpio%d/value", pinNumber);
	fd = open(path, O_RDONLY);
	if (-1 == fd) {
		fprintf(stderr, "Failed to open gpio value for reading!\n");
		return(-1);
	}
 
	if (-1 == read(fd, value_str, 3)) {
		fprintf(stderr, "Failed to read value!\n");
		return(-1);
	}
 
	close(fd);
 
	return(atoi(value_str));
}

static int GPIO_write(int pinNumber, int value){
	static const char s_values_str[] = "01";
 
	char path[VALUE_MAX];
	int fd;
 
	snprintf(path, VALUE_MAX, "/sys/class/gpio/gpio%d/value", pinNumber);
	fd = open(path, O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "Failed to open gpio value for writing!\n");
		return(-1);
	}
 
	if (1 != write(fd, &s_values_str[LOW == value ? 0 : 1], 1)) {
		fprintf(stderr, "Failed to write value!\n");
		return(-1);
	}
 
	close(fd);
	return(0);
}

int main(int argc, char *argv[]){
    //export pins
    if(
        -1 == GPIO_export(2) ||
        -1 == GPIO_export(3) ||
        -1 == GPIO_export(4) ||
        -1 == GPIO_export(5) 

    ){return 1;}

    //set directions
    if(
        -1 == GPIO_direction(2,OUT) ||
        -1 == GPIO_direction(3,OUT) ||
        -1 == GPIO_direction(4,OUT) ||
        -1 == GPIO_direction(5,OUT)
    ){return 2;}




	int repeat = 10;
	do {
        if(
            -1 == GPIO_write(2,repeat%2) ||
            -1 == GPIO_write(3,repeat%2) ||
            -1 == GPIO_write(4,repeat%2) ||
            -1 == GPIO_write(5,repeat%2)
        ){return 3;}

		usleep(500 * 1000);
	}
	while(repeat--);



    //unexport pins
    if(
        -1 == GPIO_unexport(2) ||
        -1 == GPIO_unexport(3) ||
        -1 == GPIO_unexport(4) ||
        -1 == GPIO_unexport(5) 

    ){return 5;}
    return 0;
}