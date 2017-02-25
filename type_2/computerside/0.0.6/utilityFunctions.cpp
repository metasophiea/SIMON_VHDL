std::string BINtoHEX(std::string binIn){
	//check if string can't be split into chunks of 4
	if(binIn.length() % 4 != 0){
		std::cout << "cannot turn bin string into hex string" << std::endl;
		std::cout << "bin string is: " << binIn.length() << std::endl;
		std::cout << "will only convert the first " << (unsigned int)(binIn.length()/4)*4 << " characters" << std::endl;
	}
	
	int value; 	std::string returnHex;
	for(unsigned int a = 0; a < (unsigned int)(binIn.length()/4)*4; a+=4){
		value = 0;
		if( binIn[a] == '1' ){value += 8;}
		if( binIn[a+1] == '1' ){value += 4;}
		if( binIn[a+2] == '1' ){value += 2;}
		if( binIn[a+3] == '1' ){value += 1;}
		
		switch(value){
			case 0:  returnHex += '0'; break;
			case 1:  returnHex += '1'; break;
			case 2:  returnHex += '2'; break;
			case 3:  returnHex += '3'; break;
			case 4:  returnHex += '4'; break;
			case 5:  returnHex += '5'; break;
			case 6:  returnHex += '6'; break;
			case 7:  returnHex += '7'; break;
			case 8:  returnHex += '8'; break;
			case 9:  returnHex += '9'; break;
			case 10: returnHex += 'a'; break;
			case 11: returnHex += 'b'; break;
			case 12: returnHex += 'c'; break;
			case 13: returnHex += 'd'; break;
			case 14: returnHex += 'e'; break;
			case 15: returnHex += 'f'; break;
		}
	}
	
	return returnHex;
}

std::string HEXtoBIN(std::string hexIn){
	std::string returnBin;
		
	for(unsigned int a = 0; a < hexIn.length(); a++){				
		switch(hexIn[a]){
			case '0': 			 returnBin += "0000"; break;
			case '1': 			 returnBin += "0001"; break;
			case '2': 			 returnBin += "0010"; break;
			case '3': 			 returnBin += "0011"; break;
			case '4': 			 returnBin += "0100"; break;
			case '5': 			 returnBin += "0101"; break;
			case '6': 			 returnBin += "0110"; break;
			case '7': 			 returnBin += "0111"; break;
			case '8': 			 returnBin += "1000"; break;
			case '9': 			 returnBin += "1001"; break;
			case 'a': case 'A':  returnBin += "1010"; break;
			case 'b': case 'B':  returnBin += "1011"; break;
			case 'c': case 'C':  returnBin += "1100"; break;
			case 'd': case 'D':  returnBin += "1101"; break;
			case 'e': case 'E':  returnBin += "1110"; break;
			case 'f': case 'F':  returnBin += "1111"; break;
			default: 
				std::cout << "unknown hex character: '" << hexIn[a] << "' inserting zero" << std::endl;
				returnBin += "0000";
			break;
		}
	}
	
	return returnBin;
}