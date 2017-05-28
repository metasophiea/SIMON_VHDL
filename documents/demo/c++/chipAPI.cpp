//control messages
    std::string readInputCommands[] = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "0a", "0b", "0c", "0d", "0e", "0f", "10"};
    std::string modeMethodCommand = "40";
    std::string writeInputCommands[] = {"41", "42", "43", "44", "45", "46", "47", "48", "49", "4a", "4b", "4c", "4d", "4e", "4f", "50"};
    std::string writeKeyCommands[] = {"51", "52", "53", "54", "55", "56", "57", "58", "59", "5a", "5b", "5c", "5d", "5e", "5f", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "6a", "6b", "6c", "6d", "6e", "6f", "70"};

//chip port control 
    bool setControl(std::string data){
        GPIO_write( controlPins[1], 0 );
        std::string binData = HEXtoBIN(data);
        unsigned int values[] = {0,0,0,0,0,0,0,0};
        for(unsigned int a = 0; a < binData.length(); a++){
            if(binData[a] == '0'){ values[a] = 0; }else{ values[a] = 1; }
        }

        GPIO_write( controlPins[0], values[0] );
        GPIO_write( controlPins[2], values[2] );
        GPIO_write( controlPins[3], values[3] );
        GPIO_write( controlPins[4], values[4] );
        GPIO_write( controlPins[5], values[5] );
        GPIO_write( controlPins[6], values[6] );
        GPIO_write( controlPins[7], values[7] );

        GPIO_write( controlPins[1], values[1] );

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
