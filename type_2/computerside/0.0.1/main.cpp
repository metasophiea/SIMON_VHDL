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

//test inputs
	//32_64  
		bool mode = false; unsigned int method = 0; std::string key = "1918111009080100"; std::string message = "65656877";
		//bool mode = true; unsigned int method = 0; std::string key = "1918111009080100"; std::string message = "c69be9bb";
	//48_72  
		//bool mode = false; unsigned int method = 1; std::string key = "1211100a0908020100"; std::string message = "6120676e696c";
		//bool mode = true; unsigned int method = 1; std::string key = "1211100a0908020100"; std::string message = "dae5ac292cac";
	//48_96  
		//bool mode = false; unsigned int method = 2; std::string key = "1a19181211100a0908020100"; std::string message = "72696320646e";
		//bool mode = true; unsigned int method = 2; std::string key = "1a19181211100a0908020100"; std::string message = "6e06a5acf156";
	//64_96  
		//bool mode = false; unsigned int method = 3; std::string key = "131211100b0a090803020100"; std::string message = "6f7220676e696c63";
		//bool mode = true; unsigned int method = 3; std::string key = "131211100b0a090803020100"; std::string message = "5ca2e27f111a8fc8";
	//64_128 
		//bool mode = false; unsigned int method = 4; std::string key = "1b1a1918131211100b0a090803020100"; std::string message = "656b696c20646e75";
		//bool mode = true; unsigned int method = 4; std::string key = "1b1a1918131211100b0a090803020100"; std::string message = "44c8fc20b9dfa07a";
	//96_96  
		//bool mode = false; unsigned int method = 5; std::string key = "0d0c0b0a0908050403020100"; std::string message = "2072616c6c69702065687420";
		//bool mode = true; unsigned int method = 5; std::string key = "0d0c0b0a0908050403020100"; std::string message = "602807a462b469063d8ff082";
	//96_144
		//bool mode = false; unsigned int method = 6; std::string key = "1514131211100d0c0b0a0908050403020100"; std::string message = "74616874207473756420666f";
		//bool mode = true; unsigned int method = 6; std::string key = "1514131211100d0c0b0a0908050403020100"; std::string message = "ecad1c6c451e3f59c5db1ae9";
	//128_128
		//bool mode = false; unsigned int method = 7; std::string key = "f0e0d0c0b0a09080706050403020100"; std::string message = "63736564207372656c6c657661727420";
		//bool mode = true; unsigned int method = 7; std::string key = "f0e0d0c0b0a09080706050403020100"; std::string message = "49681b1e1e54fe3f65aa832af84e0bbc";
	//128_192
		//bool mode = false; unsigned int method = 8; std::string key = "17161514131211100f0e0d0c0b0a09080706050403020100"; std::string message = "206572656874206e6568772065626972";
		//bool mode = true; unsigned int method = 8; std::string key = "17161514131211100f0e0d0c0b0a09080706050403020100"; std::string message = "c4ac61effcdc0d4f6c9c8d6e2597b85b";
	//128_256
		//bool mode = false; unsigned int method = 9; std::string key = "1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100"; std::string message = "74206e69206d6f6f6d69732061207369";
		//bool mode = true; unsigned int method = 9; std::string key = "1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100"; std::string message = "8d2b5579afc8a3a03bf72a87efe7b868";

//process
		std::string returnedMessage = processMessage(mode,method,key,message);
	
		std::cout << std::endl;
		std::cout << "Sent Message:     " << message << std::endl;
		std::cout << "Key:              " << key << std::endl;
		std::cout << "Returned Message: " << returnedMessage << std::endl;
	
	return 0;
}