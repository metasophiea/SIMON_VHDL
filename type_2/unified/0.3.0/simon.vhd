library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; 
use work.printerlib.all;

-- Methods | messageLength/keyLength | keySegmentLength | keySegments | messageSegments | messageSegmentLength | cryptLoopCount | Zselect
-- 0000    | 32/64                   | 16               | 4           | 2               | 16                   | 32             | 0
-- 0001    | 48/72                   | 24               | 3           | 2               | 24                   | 36             | 0
-- 0010    | 48/96                   | 24               | 4           | 2               | 24                   | 36             | 1
-- 0011    | 64/96                   | 32               | 3           | 2               | 32                   | 42             | 2
-- 0100    | 64/128                  | 32               | 4           | 2               | 32                   | 44             | 3
-- 0101    | 96/96                   | 48               | 2           | 2               | 48                   | 52             | 2
-- 0110    | 96/144                  | 48               | 3           | 2               | 48                   | 54             | 3
-- 0111    | 128/128                 | 64               | 2           | 2               | 64                   | 68             | 2
-- 1000    | 128/192                 | 64               | 3           | 2               | 64                   | 69             | 3
-- 1001    | 128/256                 | 64               | 4           | 2               | 64                   | 72             | 4

entity simon is
    port(
        mode, clock: in std_logic;
        method: in std_logic_vector(3 downto 0);
        keyIn: in std_logic_vector(255 downto 0) := (others => '0');
        messageIn: in std_logic_vector(127 downto 0);
        messageOut: out std_logic_vector(127 downto 0) := (others => '0')
    );
end simon;

architecture behaviour of simon is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare constants
    constant messageLength: integer := 128;
    constant keyLength: integer := 256;
    constant maxCryptLoopCount: integer := 72;
	
    -- declare Z's
    signal Z_0: std_logic_vector(61 downto 0) := "11111010001001010110000111001101111101000100101011000011100110";
    signal Z_1: std_logic_vector(61 downto 0) := "10001110111110010011000010110101000111011111001001100001011010";
    signal Z_2: std_logic_vector(61 downto 0) := "10101111011100000011010010011000101000010001111110010110110011";
    signal Z_3: std_logic_vector(61 downto 0) := "11011011101011000110010111100000010010001010011100110100001111";
    signal Z_4: std_logic_vector(61 downto 0) := "11010001111001101011011000100000010111000011001010010011101111";
    
    -- declare components
    component completeKeyExpander
        port(
            method: in std_logic_vector(3 downto 0);
            Z: in std_logic_vector(61 downto 0);
            keyIn: in std_logic_vector((keyLength-1) downto 0);
            keysOut: out std_logic_vector((keyLength*maxCryptLoopCount-1) downto 0)
        );
    end component;
    
    component messageEncrypter is
        port(
            instance: in std_logic_vector(7 downto 0);
            method: in std_logic_vector(3 downto 0);
            keyIn: in std_logic_vector((keyLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component;
    
    component messageDecrypter is
        port(
            instance: in std_logic_vector(7 downto 0);
            method: in std_logic_vector(3 downto 0);
            keyIn: in std_logic_vector((keyLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component; 
    
	component latcher is
        port(
            -- mode(1) | method(4) | encrypt message(128) | decrypt message(128) | keys(18432) = 18693
            clock: in std_logic := '0';
            input: in std_logic_vector((1+4+messageLength*2+keyLength*maxCryptLoopCount-1) downto 0); 
            output: out std_logic_vector((1+4+messageLength*2+keyLength*maxCryptLoopCount-1) downto 0) := (others => '0')
        );
    end component;
    
    -- internal latches
    type latchAttachments_mode_type     is array (0 to maxCryptLoopCount) of std_logic;  
    type latchAttachments_method_type   is array (0 to maxCryptLoopCount) of std_logic_vector(3 downto 0);   
    type latchAttachments_message_type  is array (0 to maxCryptLoopCount) of std_logic_vector((messageLength-1) downto 0);
    type latchAttachments_keys_type     is array (0 to maxCryptLoopCount) of std_logic_vector((keyLength*maxCryptLoopCount-1) downto 0);
    
    signal latchAttachments_mode_toLatch, latchAttachments_mode_fromLatch: latchAttachments_mode_type := ( others => '0' );
    signal latchAttachments_method_toLatch, latchAttachments_method_fromLatch: latchAttachments_method_type := ( others => (others => '0') ); 
    signal latchAttachments_encryptMessage_toLatch, latchAttachments_encryptMessage_fromLatch: latchAttachments_message_type := ( others => (others => '0') );
    signal latchAttachments_decryptMessage_toLatch, latchAttachments_decryptMessage_fromLatch: latchAttachments_message_type := ( others => (others => '0') );
    signal latchAttachments_keys_toLatch, latchAttachments_keys_fromLatch: latchAttachments_keys_type := ( others => (others => '0') );
    
    signal selected_Z: std_logic_vector(61 downto 0);
    
begin
    -- connect inputs
    latchAttachments_mode_toLatch(0) <= mode;
    latchAttachments_method_toLatch(0) <= method;
    latchAttachments_encryptMessage_toLatch(0) <= messageIn;
    latchAttachments_decryptMessage_toLatch(0) <= messageIn;
	
    -- select Z baised on selected method
    selected_Z <= Z_0 when (method = "0000" or method = "0001") else
                  Z_1 when (method = "0010") else
                  Z_2 when (method = "0011" or method = "0101" or method = "0111") else
                  Z_3 when (method = "0100" or method = "0110" or method = "1000") else
                  Z_4; 

	-- generate and connect components
	completekeyExpansion: completeKeyExpander port map(
		method => method,
		Z => selected_Z,
		keyIn => keyIn,
		keysOut => latchAttachments_keys_toLatch(0)
	); 
	
    latcher_generation:for a in 0 to (maxCryptLoopCount) generate
        latches: latcher port map(
            clock => clock,
            -- mode(1) | method(4) | message(128) | keys(18432)
            input(0)                                                                                    => latchAttachments_mode_toLatch(a),
            input(4                                                    downto 1)                        => latchAttachments_method_toLatch(a),   
            input((1+4+messageLength-1)                                downto 4+1)                      => latchAttachments_encryptMessage_toLatch(a),
            input((1+4+messageLength*2-1)                              downto (1+4+messageLength))      => latchAttachments_decryptMessage_toLatch(a),  
            input((1+4+messageLength*2+keyLength*maxCryptLoopCount-1)  downto (1+4+messageLength*2))    => latchAttachments_keys_toLatch(a),         
            
            output(0)                                                                                   => latchAttachments_mode_fromLatch(a),
            output(4                                                    downto 1)                       => latchAttachments_method_fromLatch(a),   
            output((1+4+messageLength-1)                                downto 4+1)                     => latchAttachments_encryptMessage_fromLatch(a),
            output((1+4+messageLength*2-1)                              downto (1+4+messageLength))     => latchAttachments_decryptMessage_fromLatch(a),  
            output((1+4+messageLength*2+keyLength*maxCryptLoopCount-1)  downto (1+4+messageLength*2))   => latchAttachments_keys_fromLatch(a)
        );
    end generate;
    
    encrypterDecrypter_generation:for a in 0 to (maxCryptLoopCount-1) generate
        latchAttachments_mode_toLatch(a+1) <= latchAttachments_mode_fromLatch(a);
        latchAttachments_keys_toLatch(a+1) <= latchAttachments_keys_fromLatch(a);
        latchAttachments_method_toLatch(a+1) <= latchAttachments_method_fromLatch(a);
        
        encryptMessage: messageEncrypter port map(
            instance => std_logic_vector(to_unsigned(a,8)),
            method => latchAttachments_method_fromLatch(a),  
            keyIn => latchAttachments_keys_fromLatch(a)( (a*keyLength + (keyLength-1)) downto (a*keyLength) ),  
            messageIn => latchAttachments_encryptMessage_fromLatch(a),
            messageOut => latchAttachments_encryptMessage_toLatch(a+1)
        );
        
        decryptMessage: messageDecrypter port map(
            instance => std_logic_vector(to_unsigned(a,8)),
            method => latchAttachments_method_fromLatch(a),  
            keyIn => latchAttachments_keys_fromLatch(a)( ((maxCryptLoopCount-1-a)*keyLength + (keyLength-1)) downto ((maxCryptLoopCount-1-a)*keyLength) ),  
            messageIn => latchAttachments_decryptMessage_fromLatch(a),
            messageOut => latchAttachments_decryptMessage_toLatch(a+1)
        );
    end generate;
    
    -- connect output
    messageOut <= latchAttachments_encryptMessage_fromLatch(maxCryptLoopCount) when latchAttachments_mode_fromLatch(maxCryptLoopCount) = '0' else latchAttachments_decryptMessage_fromLatch(maxCryptLoopCount);
	
end behaviour;
