library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Methods | messageLength/keyLength | keySegmentLength | keySegments | messageSegments | messageSegmentLength | cryptLoopCount | Zselect
-- 0011    | 64/96                   | 32               | 3           | 2               | 32                   | 42             | 2

entity simon is
    port(
        mode, clock: in std_logic;
        keyIn: in std_logic_vector(95 downto 0) := (others => '0');
        messageIn: in std_logic_vector(63 downto 0) := (others => '0');
        messageOut: out std_logic_vector(63 downto 0) := (others => '0')
    );
end simon;

architecture behaviour of simon is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare constants
    constant messageLength: integer := 64;
    constant keyLength: integer := 96;
    constant maxCryptLoopCount: integer := 42;
    constant keySegments: integer := 3;
    constant keySegmentLength: integer := keyLength/keySegments;
	
    -- declare components
    component completeKeyExpander
        port(
            Z: in std_logic_vector(61 downto 0);
            keyIn: in std_logic_vector((keyLength-1) downto 0);
            keysOut: out std_logic_vector((keySegmentLength*maxCryptLoopCount -1) downto 0)
        );
    end component;
    
    component messageEncrypter is
        port(
            instance: in std_logic_vector(7 downto 0);
            keyIn: in std_logic_vector((keySegmentLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component;
    
    component messageDecrypter is
        port(
            instance: in std_logic_vector(7 downto 0);
            keyIn: in std_logic_vector((keySegmentLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component; 
    
	component latcher is
        port(
            -- mode(1) | encrypt message(64) | decrypt message(64) | keys((96/3)*42 = 1344) = 1473
            clock: in std_logic := '0';
            input: in std_logic_vector((1+messageLength*2+keySegmentLength*maxCryptLoopCount-1) downto 0); 
            output: out std_logic_vector((1+messageLength*2+keySegmentLength*maxCryptLoopCount-1) downto 0) := (others => '0')
        );
    end component;
    
    -- internal latches
    type latchAttachments_mode_type     is array (0 to maxCryptLoopCount) of std_logic;  
    type latchAttachments_message_type  is array (0 to maxCryptLoopCount) of std_logic_vector((messageLength-1) downto 0);
    type latchAttachments_keys_type   is array (0 to maxCryptLoopCount) of std_logic_vector((keySegmentLength*maxCryptLoopCount-1) downto 0);

    signal latchAttachments_mode_toLatch, latchAttachments_mode_fromLatch: latchAttachments_mode_type := ( others => '0' );
    signal latchAttachments_encryptMessage_toLatch, latchAttachments_encryptMessage_fromLatch: latchAttachments_message_type := ( others => (others => '0') );
    signal latchAttachments_decryptMessage_toLatch, latchAttachments_decryptMessage_fromLatch: latchAttachments_message_type := ( others => (others => '0') );
    signal latchAttachments_keys_toLatch, latchAttachments_keys_fromLatch: latchAttachments_keys_type := ( others => (others => '0') );
    
    signal selected_Z: std_logic_vector(61 downto 0);
    
begin
    -- connect inputs
    latchAttachments_mode_toLatch(0) <= mode;
    latchAttachments_encryptMessage_toLatch(0) <= messageIn;
    latchAttachments_decryptMessage_toLatch(0) <= messageIn;
	
    -- select Z baised on selected method
    selected_Z <= "10101111011100000011010010011000101000010001111110010110110011";

	-- generate and connect components
	completekeyExpansion: completeKeyExpander port map(
		Z => selected_Z,
		keyIn => keyIn,
		keysOut => latchAttachments_keys_toLatch(0)
	); 
	
    latcher_generation:for a in 0 to (maxCryptLoopCount) generate
        latches: latcher port map(
            clock => clock,
            -- mode(1) | encrypt message(64) | decrypt message(64) | keys((96/3)*42 = 1344) 
            input(0)                                                                                        => latchAttachments_mode_toLatch(a),
            input((1+messageLength-1)                                       downto 1)                       => latchAttachments_encryptMessage_toLatch(a),
            input((1+messageLength*2-1)                                     downto (1+messageLength))       => latchAttachments_decryptMessage_toLatch(a),  
            input((1+messageLength*2+keySegmentLength*maxCryptLoopCount-1)  downto (1+messageLength*2))     => latchAttachments_keys_toLatch(a),         
            
            output(0)                                                                                       => latchAttachments_mode_fromLatch(a),
            output((1+messageLength-1)                                       downto 1)                      => latchAttachments_encryptMessage_fromLatch(a),
            output((1+messageLength*2-1)                                     downto (1+messageLength))      => latchAttachments_decryptMessage_fromLatch(a),  
            output((1+messageLength*2+keySegmentLength*maxCryptLoopCount-1)  downto (1+messageLength*2))    => latchAttachments_keys_fromLatch(a)
        );
    end generate;
    
    encrypterDecrypter_generation:for a in 0 to (maxCryptLoopCount-1) generate
        latchAttachments_mode_toLatch(a+1) <= latchAttachments_mode_fromLatch(a);
        latchAttachments_keys_toLatch(a+1) <= latchAttachments_keys_fromLatch(a);
        
        encryptMessage: messageEncrypter port map(
            instance => std_logic_vector(to_unsigned(a,8)),
            keyIn => latchAttachments_keys_fromLatch(a)( (a*keySegmentLength + (keySegmentLength-1)) downto (a*keySegmentLength) ),  
            messageIn => latchAttachments_encryptMessage_fromLatch(a),
            messageOut => latchAttachments_encryptMessage_toLatch(a+1)
        );
        
        decryptMessage: messageDecrypter port map(
            instance => std_logic_vector(to_unsigned(a,8)),
            keyIn => latchAttachments_keys_fromLatch(a)( ((maxCryptLoopCount-1-a)*keySegmentLength + (keySegmentLength-1)) downto ((maxCryptLoopCount-1-a)*keySegmentLength) ),  
            messageIn => latchAttachments_decryptMessage_fromLatch(a),
            messageOut => latchAttachments_decryptMessage_toLatch(a+1)
        );
    end generate;
    
    -- connect output
    messageOut <= latchAttachments_encryptMessage_fromLatch(maxCryptLoopCount) when latchAttachments_mode_fromLatch(maxCryptLoopCount) = '0' else latchAttachments_decryptMessage_fromLatch(maxCryptLoopCount);
	
end behaviour;