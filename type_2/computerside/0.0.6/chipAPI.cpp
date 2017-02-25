//control messages
    std::string readInputCommands[] = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "0a", "0b", "0c", "0d", "0e", "0f", "10"};
    std::string modeMethodCommand = "40";
    std::string writeInputCommands[] = {"41", "42", "43", "44", "45", "46", "47", "48", "49", "4a", "4b", "4c", "4d", "4e", "4f", "50"};
    std::string writeKeyCommands[] = {"81", "82", "83", "84", "85", "86", "87", "88", "89", "8a", "8b", "8c", "8d", "8e", "8f", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "9a", "9b", "9c", "9d", "9e", "9f", "a0"};

//chip port control 
    bool setClock(bool value){
            if( !GPIO_write( controlPins[7], values ) ){
                std::cout << "- error:setClock: failed on clock pin" << std::endl;
                return false;
            }
        return true;
    }

    bool setControl(std::string data){
        std::string binData = HEXtoBIN(data);
        
        unsigned int values[] = {0,0,0,0,0,0,0,0};
        for(unsigned int a = 0; a < binData.length(); a++){
            if(binData[a] == '0'){ values[a] = 0; }else{ values[a] = 1; }
        }
        
        for(unsigned int a = 0; a < (sizeof(controlPins)/sizeof(*controlPins))-1; a++){
            if( !GPIO_write( controlPins[a], values[a] ) ){
                std::cout << "- error:setControl: failed on pin: " << a << std::endl;
                return false;
            }
        }

        return true;
    }

    bool setInput(std::string data){	
        std::string binData = HEXtoBIN(data);
        
        unsigned int values[] = {0,0,0,0,0,0,0,0};
        for(unsigned int a = 0; a < binData.length(); a++){
            if(binData[a] == '0'){ values[a] = 0; }else{ values[a] = 1; }
        }

        for(unsigned int a = 0; a < (sizeof(inputPins)/sizeof(*inputPins)); a++){
            if( !GPIO_write( inputPins[a], values[a] ) ){
                std::cout << "- error:setInput: failed on pin: " << a << std::endl;
                return false;
            }
        }
        
        return true;
    }

    std::string readOutput(){ 
        std::string data;
        for(unsigned int a = 0; a < (sizeof(outputPins)/sizeof(*outputPins)); a++){ 
            if( GPIO_read(outputPins[a]) == 0){ data += '0'; }else{ data += '1'; }
        }
        
        return BINtoHEX(data);
    }

//abstracted
    bool writeModeAndMethod(bool mode, unsigned int method){
        if(!setControl("40")){std::cout << "- error:writeModeAndMethod: could not set control" << std::endl; return false;}
        
        std::string data = "000";
        switch(method){
            case 0: data += "0000"; break;
            case 1: data += "0001"; break;
            case 2: data += "0010"; break;
            case 3: data += "0011"; break;
            case 4: data += "0100"; break;
            case 5: data += "0101"; break;
            case 6: data += "0110"; break;
            case 7: data += "0111"; break;
            case 8: data += "1000"; break;
            case 9: data += "1001"; break;
            default: data += "0000"; break;
        }
        
        if(!mode){data += '0';}else{data += '1';}
        
        return setInput(BINtoHEX(data));
    }

    bool writeMessage(unsigned int segmentCount, std::string message){
        //pad message out
        while(message.length()/4 < segmentCount){ message = "00" + message; }
        
        std::string temp;
        
        for(unsigned int a = 0; a < segmentCount; a+=2){
            if(!setControl(writeInputCommands[a/2])){std::cout << "- error:writeMessage: failed to set control pins" << std::endl; return false;};
            temp = ""; 
            temp += message[message.length()- (a+2) ];
            temp += message[message.length()- (a+1) ]; 
            if(!setInput( temp )){std::cout << "- error:writeMessage: failed to set input pins" << std::endl; return false;};
        }

        std::cout << std::endl;
        return true;
    }

    bool writeKey(unsigned int segmentCount, std::string key){
        //pad key out
        while(key.length()/4 < segmentCount){ key = "00" + key; }
        
        std::string temp;
        
        for(unsigned int a = 0; a < segmentCount; a+=2){
            setControl(writeKeyCommands[a/2]);
            temp = ""; 
            temp += key[key.length()- (a+2) ];
            temp += key[key.length()- (a+1) ]; 
            setInput( temp );		
        }
        
        std::cout << std::endl;
        return true;
    }
    std::string readMessage(unsigned int segmentCount){
        std::string response;
        
        for(unsigned int a = 0; a < segmentCount/2; a++){
            setControl(readInputCommands[a]);
            response = readOutput() + response; 
        }
        
        return response;
    }