#include <iostream>
#include <fstream>
#include <stdio.h> 
#include <string>
#include <algorithm>

#include "./raspberryPI_api.cpp"
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



	// //gather control info
	// 	std::ifstream controlfile((controlFileAddress).c_str());
	// 	std::string key; bool mode = false; 
	// 	getline( controlfile,tempString ); key = tempString;
	// 	getline( controlfile,tempString ); if( tempString.compare("encrypt") ){ mode = true; }

	// //process each line in the input and put result in the output
	// 	std::ifstream inputfile((inputFileAddress).c_str());
	// 	while(getline( inputfile,tempString )){
	// 		std::cout << tempString << std::endl;

	// 		//tempString = processMessage(mode,0,key,tempString);
	// 			//std::rotate(tempString.begin(),tempString.begin()+1,tempString.end());

	// 		appendStringToFile(outputFileAddress,tempString+"\n");
	// 	}

	// //find next line in output
	// 	std::ifstream outputfile((outputFileAddress).c_str()); 
	// 	unsigned int nextLine = 0;
	// 	while(getline( outputfile,line )){ ++nextLine; }

	// //get this line from the input
	// 	std::ifstream inputfile((inputFileAddress).c_str());
	// 	unsigned int count = 0;
	// 	while(getline( inputfile,tempString )){
	// 		if(count == nextLine){ line = tempString; }
	// 		++count;
	// 	}

	// //check if there are no more lines
	// 	if( count <= nextLine ){ return 0; }
	
	// //check if this line is empty
	// 	if( line.length() == 0){ return 0; }
	// 	//std::cout << "|" << line << "|" << line.length() << std::endl;

	// //gather control info
	// 	std::ifstream controlfile((controlFileAddress).c_str());
	// 	std::string key; bool mode = false; 
	// 	getline( controlfile,tempString ); key = tempString;
	// 	getline( controlfile,tempString ); if( tempString.compare("encrypt") ){ mode = true; }

	// //perform work
	// 	//std::string returnedMessage = processMessage(mode,0,key,line);
	// 	std::rotate(line.begin(),line.begin()+1,line.end());
	// 	std::string returnedMessage = line;

	// //print returned message to output
	// 	if(nextLine != 0){ returnedMessage = "\n" + returnedMessage; }
	// 	appendStringToFile(outputFileAddress,returnedMessage);
	
	return 0;
}