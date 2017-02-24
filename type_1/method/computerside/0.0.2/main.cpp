#include <iostream>
#include <string>

#include "./raspberryPI_api.cpp"
#include "./utilityFunctions.cpp"
#include "./chipAPI.cpp"
#include "./messageProcessing.cpp"

int main(){
	std::cout << "Hello" << std::endl;
/*	
	//get mode
		std::string modeSel; bool mode;
		std::cout << "Select mode (enc or dec): "; std::cin >> modeSel;
		if(modeSel == "enc"){ mode = false;}
		else if(modeSel == "dec"){ mode = true; }
		else{ std::cout << "- error: mode '" << modeSel << "' is not available" << std::endl; return 0; }
	//get method	
		unsigned int method;
		std::cout << "Select Method (0-9): "; std::cin >> method;
		if(method > 9){ std::cout << "- error: method '" << method << "' is not available" << std::endl; return 0;}
	//get key
		std::string key; unsigned int keyLengthRequirement;
		std::cout << "Required key length: ";
		switch(method){
			case 0: keyLengthRequirement = 16; break;
			case 1: keyLengthRequirement = 18; break;
			case 2: keyLengthRequirement = 24; break;
			case 3: keyLengthRequirement = 24; break;
			case 4: keyLengthRequirement = 32; break;
			case 5: keyLengthRequirement = 24; break;
			case 6: keyLengthRequirement = 36; break;
			case 7: keyLengthRequirement = 32; break;
			case 8: keyLengthRequirement = 48; break;
			case 9: keyLengthRequirement = 64; break;
		}		
		std::cout << keyLengthRequirement << std::endl;
		std::cout << "	Insert key: "; std::cin >> key;
		if(key.length() != keyLengthRequirement){
			std::cout << "- error: provided key is the wrong length" << std::endl;
			std::cout << "	required: " << keyLengthRequirement << std::endl;
			std::cout << "	provided: " << key.length() << std::endl;
			return 0;
		}
		key = HEXtoBIN(key);
	//get message
		std::string message; unsigned int messageLengthRequirement;
		std::cout << "Required message length: ";
		switch(method){
			case 0: messageLengthRequirement = 8; break;
			case 1: messageLengthRequirement = 12; break;
			case 2: messageLengthRequirement = 12; break;
			case 3: messageLengthRequirement = 16; break;
			case 4: messageLengthRequirement = 16; break;
			case 5: messageLengthRequirement = 24; break;
			case 6: messageLengthRequirement = 24; break;
			case 7: messageLengthRequirement = 32; break;
			case 8: messageLengthRequirement = 32; break;
			case 9: messageLengthRequirement = 32; break;
		}		
		std::cout << messageLengthRequirement << std::endl;
		std::cout << "	Insert message: "; std::cin >> message;
		if(message.length() != messageLengthRequirement){
			std::cout << "- error: provided message is the wrong length" << std::endl;
			std::cout << "	required: " << messageLengthRequirement << std::endl;
			std::cout << "	provided: " << message.length() << std::endl;
			return 0;
		}
		message = HEXtoBIN(message);
*/		
		
		bool mode = false; unsigned int method = 9; std::string key = "1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100"; std::string message = "74206e69206d6f6f6d69732061207369";
//process
		std::string returnedMessage = processMessage(mode,method,key,message);
	
		std::cout << std::endl;
		std::cout << "Sent Message:     " << message << std::endl;
		std::cout << "Key:              " << key << std::endl;
		std::cout << "Returned Message: " << returnedMessage << std::endl;
	
	return 0;
}