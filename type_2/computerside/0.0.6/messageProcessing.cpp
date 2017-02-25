std::string processMessage(bool mode, unsigned int method, std::string key, std::string message){
	if(!setUpPins()){std::cout << "- error:processMessage: failed to set up pins" << std::endl; return "process failure";}
	
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
	
	if(!writeModeAndMethod(mode,method)){std::cout << "- error:processMessage: failed to write method and mode" << std::endl; return "process failure";}
	if(!writeMessage(messageSegmentCount,message)){std::cout << "- error:processMessage: failed to write message" << std::endl; return "process failure";}
	if(!writeKey(keySegmentCount,key)){std::cout << "- error:processMessage: failed to write key" << std::endl; return "process failure";}

	for(unsigned int a = 0; a < 50; a++){
		setClock(true);
		setClock(false);
	}

	std::string response = readMessage(messageSegmentCount);

	if(!shutDownPins()){std::cout << "- error:processMessage: failed to shut down pins" << std::endl; return "process failure";}
	return response;
}