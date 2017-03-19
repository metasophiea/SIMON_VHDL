std::string processMessage(bool mode, unsigned int method, std::string key, std::string message){
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
	if(!writeMessage(messageSegmentCount,message)){std::cout << "- error:processMessage: failed to write message" << std::endl; return "process failure";}

	//clock in
		if(!setClock(true)){  std::cout << "- error:processMessage: failed to write clock" << std::endl; return "process failure"; }
		if(!setClock(false)){ std::cout << "- error:processMessage: failed to write clock" << std::endl; return "process failure"; }

	//push through registers
		for(unsigned int a = 0; a < registerCount; a++){
			if(!setClock(true)){  std::cout << "- error:processMessage: failed to write clock" << std::endl; return "process failure"; }
			if(!setClock(false)){ std::cout << "- error:processMessage: failed to write clock" << std::endl; return "process failure"; }
		}

	std::string response = readMessage(messageSegmentCount);

	if(!shutDownPins()){std::cout << "- error:processMessage: failed to shut down pins" << std::endl; return "process failure";}
	return response;
}