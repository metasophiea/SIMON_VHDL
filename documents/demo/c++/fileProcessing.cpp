#include <fstream>
#include <stdio.h> 
#include <unistd.h>

void writeStringToFile(FILE* file, std::string str){
    for(int a = 0; a < str.length(); a++){ fprintf(file, "%c", str[a]); }
}

bool processFile(bool mode, unsigned int method, std::string key, std::string input_fileAddress, std::string output_fileAddress){
	std::ifstream inputFile((input_fileAddress).c_str());
	FILE* output = fopen((output_fileAddress).c_str(), "w");

	std::string line;
	while(getline( inputFile, line )){
		writeStringToFile(output, processMessage(mode, method, key, line) + "\n");
	}

	return true;
}