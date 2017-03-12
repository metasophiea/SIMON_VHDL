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
        mode, clock, load: in std_logic;
        method: in std_logic_vector(3 downto 0);
        keyIn: in std_logic_vector(255 downto 0);
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

    -- internal signals
        signal internal_mode: std_logic := '0';
        signal internal_method: std_logic_vector(3 downto 0) := (others => '0');
        signal internal_key: std_logic_vector(keyLength-1 downto 0) := (others => '0');
        signal internal_messageIn, internal_messageOut_encrypt, internal_messageOut_decrypt: std_logic_vector(messageLength-1 downto 0) := (others => '0');
        
        signal completeKeys: std_logic_vector((keyLength*maxCryptLoopCount-1) downto 0) := (others => '0');
        signal useKey: std_logic_vector((keyLength-1) downto 0) := (others => '0');
        signal selected_Z: std_logic_vector(61 downto 0);
        
        shared variable processStage: integer := 0;
        shared variable processLimit: integer := 72;
begin

    -- select Z baised on selected method
        selected_Z <= Z_0 when (internal_method = "0000" or internal_method = "0001") else
                      Z_1 when (internal_method = "0010") else
                      Z_2 when (internal_method = "0011" or internal_method = "0101" or internal_method = "0111") else
                      Z_3 when (internal_method = "0100" or internal_method = "0110" or internal_method = "1000") else
                      Z_4; 

	-- connect components
        completekeyExpansion: completeKeyExpander port map(
            method => internal_method,
            Z => selected_Z,
            keyIn => internal_key,
            keysOut => completeKeys
        ); 
        
        encryptMessage: messageEncrypter port map(
            instance => std_logic_vector(to_unsigned(0,8)),
            method => internal_method,  
            keyIn => useKey,  
            messageIn => internal_messageIn,
            messageOut => internal_messageOut_encrypt
        );
        
        decryptMessage: messageDecrypter port map(
            instance => std_logic_vector(to_unsigned(72,8)),
            method => internal_method,  
            keyIn => useKey,  
            messageIn => internal_messageIn,
            messageOut => internal_messageOut_decrypt
        );  
        
    process(clock) begin
        if(rising_edge(clock))then
            if(load = '1')then
                processStage := 0;
                internal_mode <= mode;
                internal_method <= method;
                internal_key <= keyIn;
                internal_messageIn <= messageIn;
                
                case method is
                    when "0000" => processLimit := 32;
                    when "0001" => processLimit := 36;
                    when "0010" => processLimit := 36;
                    when "0011" => processLimit := 42;
                    when "0100" => processLimit := 44;
                    when "0101" => processLimit := 52;
                    when "0110" => processLimit := 54;
                    when "0111" => processLimit := 68;
                    when "1000" => processLimit := 69;
                    when "1001" => processLimit := 72;
                    when others => processLimit := 72;
                end case;
            else
                if(processStage >= processLimit)then
                    if(internal_mode = '0')then
                        messageOut <= internal_messageOut_encrypt;
                    else
                        messageOut <= internal_messageOut_decrypt;
                    end if;
                elsif(processStage = 0)then
                    if(internal_mode = '0')then
                        useKey <= completeKeys( (keyLength-1) downto 0 );     
                    else
                        useKey <= completeKeys( (maxCryptLoopCount-processStage-1 - (maxCryptLoopCount-processLimit))*keyLength + (keyLength-1) downto (maxCryptLoopCount-processStage-1 - (maxCryptLoopCount-processLimit))*keyLength );                       
                    end if;
                else
                    if(internal_mode = '0')then
                        useKey <= completeKeys( (processStage*keyLength + (keyLength-1)) downto (processStage*keyLength) );      
                        internal_messageIn <= internal_messageOut_encrypt;             
                    else
                        useKey <= completeKeys( (maxCryptLoopCount-processStage-1 - (maxCryptLoopCount-processLimit))*keyLength + (keyLength-1) downto (maxCryptLoopCount-processStage-1 - (maxCryptLoopCount-processLimit))*keyLength );                       
                        internal_messageIn <= internal_messageOut_decrypt;
                    end if;
                end if;
                processStage := processStage + 1;
            end if;
        end if;
    end process;

end behaviour;