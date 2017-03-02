#include <fstream>
#include <stdio.h> 

void writeStringToFile(FILE* file, std::string str){
    for(int a = 0; a < str.length(); a++){ fprintf(file, "%c", str[a]); }
}

bool processFile(bool mode, unsigned int method, std::string key, std::string fileAddress){
	std::ifstream inputFile((fileAddress).c_str());
	FILE* output = fopen(("output_"+fileAddress).c_str(), "w");
		
	std::string line; unsigned int count = 0;
	while(getline( inputFile, line )){
		std::cout << count << "|\t" << line << std::endl;
		std::cout << "\t" << processMessage(mode,method,key,line) << std::endl;
		std::cout << std::endl;
		
		writeStringToFile(output,processMessage(mode,method,key,line));
		writeStringToFile(output,"\n");
		
		count++;
	}
	
	return true;
}