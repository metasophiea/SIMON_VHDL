//compile with: g++ main.cpp -lwiringPi

#include <iostream>
#include <fstream>
#include <stdio.h> 
#include <string>
#include <algorithm>

//select pin interfacing type
	//#include "./raspberryPI_apiSYSFS.cpp"
	#include "./raspberryPI_api_wiringPi.cpp"

#include "./utilityFunctions.cpp"
#include "./chipAPI.cpp"
#include "./messageProcessing.cpp"
#include "./fileProcessing.cpp"

void appendStringToFile(std::string fileAddress, std::string str){
	FILE* file = fopen((fileAddress).c_str(), "a");
    for(int a = 0; a < str.length(); a++){ fprintf(file, "%c", str[a]); }
}

int main(){
	std::string inputFileAddress = "../files/input";
	std::string outputFileAddress = "../files/output";
	std::string controlFileAddress = "../files/control";
	std::string tempString;

	//gather control info
		std::ifstream controlfile((controlFileAddress).c_str());
		std::string key; bool mode = false; 
		getline( controlfile,tempString ); key = tempString;
		getline( controlfile,tempString ); if( tempString.compare("encrypt") ){ mode = true; }

	//process file
		processFile(mode, 0, key, inputFileAddress, outputFileAddress);
	
	return 0;
}