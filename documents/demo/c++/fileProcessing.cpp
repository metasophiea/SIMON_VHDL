#include <fstream>
#include <stdio.h> 
#include <unistd.h>

void writeStringToFile(FILE* file, std::string str){
    for(int a = 0; a < str.length(); a++){ fprintf(file, "%c", str[a]); }
}

bool processFile(bool mode, unsigned int method, std::string key, std::string input_fileAddress, std::string output_fileAddress){
	if(!setUpPins()){std::cout << "- error:processFile: failed to set up pins" << std::endl; return "process failure";}
	unsigned int messageSegmentCount, keySegmentCount;
	switch(method){
		case 0: messageSegmentCount = 8;  keySegmentCount = 16; break;
		case 1: messageSegmentCount = 12; keySegmentCount = 18; break;
		case 2: messageSegmentCount = 12; keySegmentCount = 24; break;
		case 3: messageSegmentCount = 16; keySegmentCount = 24; break;
		case 4: messageSegmentCount = 16; keySegmentCount = 32; break;
		case 5: messageSegmentCount = 24; keySegmentCount = 24; break;
		case 6: messageSegmentCount = 24; keySegmentCount = 36; break;
		case 7: messageSegmentCount = 32; keySegmentCount = 32; break;
		case 8: messageSegmentCount = 32; keySegmentCount = 48; break;
		case 9: messageSegmentCount = 32; keySegmentCount = 64; break;
	}	
	if(!writeModeAndMethod(mode,method)){std::cout << "- error:processFile: failed to write method and mode" << std::endl; return "process failure";}
	if(!writeKey(keySegmentCount,key)){std::cout << "- error:processFile: failed to write key" << std::endl; return "process failure";}

	std::ifstream inputFile((input_fileAddress).c_str());
	FILE* output = fopen((output_fileAddress).c_str(), "w");

	std::string line;
	while(getline( inputFile, line )){
		if(!writeMessage(messageSegmentCount,line)){std::cout << "- error:processFile: failed to write message" << std::endl; return "process failure";}
		writeStringToFile(output,readMessage(messageSegmentCount)+"\n");

		std::cout << line << " | " << key << " | " << readMessage(messageSegmentCount) << std::endl;

		usleep(100);
	}

	if(!shutDownPins()){std::cout << "- error:processFile: failed to shut down pins" << std::endl; return "process failure";}
	return true;
}