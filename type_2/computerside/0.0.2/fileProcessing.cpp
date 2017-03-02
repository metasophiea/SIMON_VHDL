#include <fstream>
#include <stdio.h> 
#include <string>

void writeStringToFile(FILE* file, std::string str){
    for(int a = 0; a < str.length(); a++){ fprintf(file, "%c", str[a]); }
}

bool processFile(bool mode, unsigned int method, std::string key, std::string fileAddress){
	if(!setUpPins()){std::cout << "- error:processMessage: failed to set up pins" << std::endl; return "process failure";}
	
	unsigned int messageSegmentCount, keySegmentCount, registerCount;
	switch(method){
		case 0: messageSegmentCount = 8;  keySegmentCount = 16; registerCount = 32; break;
		case 1: messageSegmentCount = 12; keySegmentCount = 18; registerCount = 36; break;
		case 2: messageSegmentCount = 12; keySegmentCount = 24; registerCount = 36; break;
		case 3: messageSegmentCount = 16; keySegmentCount = 24; registerCount = 42; break;
		case 4: messageSegmentCount = 16; keySegmentCount = 32; registerCount = 44; break;
		case 5: messageSegmentCount = 24; keySegmentCount = 24; registerCount = 52; break;
		case 6: messageSegmentCount = 24; keySegmentCount = 36; registerCount = 54; break;
		case 7: messageSegmentCount = 32; keySegmentCount = 32; registerCount = 68; break;
		case 8: messageSegmentCount = 32; keySegmentCount = 48; registerCount = 69; break;
		case 9: messageSegmentCount = 32; keySegmentCount = 64; registerCount = 72; break;
	}		
	
	if(!writeModeAndMethod(mode,method)){std::cout << "- error:processMessage: failed to write method and mode" << std::endl; return "process failure";}
	if(!writeKey(keySegmentCount,key)){std::cout << "- error:processMessage: failed to write key" << std::endl; return "process failure";}
	
	std::string line; unsigned int count = 0; unsigned int fileLength = 0;
	std::ifstream inputFile((fileAddress).c_str());
	FILE* output = fopen(("output_"+fileAddress).c_str(), "w");
	while(getline( inputFile, line )){		
		if(!writeMessage(messageSegmentCount,line)){std::cout << "- error:processMessage: failed to write message" << std::endl; return "process failure";}
		if(!setClock(true)){  std::cout << "- error:processMessage: failed to write clock" << std::endl; return "process failure"; }
		if(!setClock(false)){ std::cout << "- error:processMessage: failed to write clock" << std::endl; return "process failure"; }
		
		writeStringToFile(output,readMessage(messageSegmentCount));
		writeStringToFile(output,"\n");

		if(count > registerCount-1){
			std::cout << "- writing out: " << count << std::endl;
			writeStringToFile(output,readMessage(messageSegmentCount));
			writeStringToFile(output,"\n");
		}	
		
		std::cout << count << "|\t" << line << std::endl;
		std::cout << "\t" << readMessage(messageSegmentCount) << std::endl;
		std::cout << std::endl;
		
		count++; fileLength = count;
	}
	
	std::cout << "End of input, pushing the rest of the message through" << std::endl << std::endl;

	
	while(count < registerCount+fileLength){
		if(count > registerCount-1){
			std::cout << "- writing out: " << count << std::endl;
			writeStringToFile(output,readMessage(messageSegmentCount));
			writeStringToFile(output,"\n");
		}
		
		if(!setClock(true)){  std::cout << "- error:processMessage: failed to write clock" << std::endl; return "process failure"; }
		if(!setClock(false)){ std::cout << "- error:processMessage: failed to write clock" << std::endl; return "process failure"; }
		std::cout << count << "|\t" << readMessage(messageSegmentCount) << std::endl;
		
		count++;
	}
	
	return true;
}