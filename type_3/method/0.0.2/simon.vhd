--      ________  ___  _____     _____   ___________  _____     ___ 
--     /  _____/ /  / /     |   /     | |   ____   / /     |   /  /  
--    /  /____  /  / /  /|  |  /  /|  | |  |   /  / /  /|  |  /  /   
--   /____   / /  / /  / |  | /  / |  | |  |  /  / /  / |  | /  / 
--  _____/  / /  / /  /  |  |/  /  |  | |  |_/  / /  /  |  |/  /   
-- /_______/ /__/ /__/   |_____/   |__| |______/ /__/   |_____/ 
--						VHDL - Brandon Walsh

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity simon is
    port(
        mode, clock, load: in std_logic;
        keyIn: in std_logic_vector(keyLength-1 downto 0) := (others => '0');
        messageIn: in std_logic_vector(messageLength-1 downto 0) := (others => '0');
        messageOut: out std_logic_vector(messageLength-1 downto 0) := (others => '0')
    );
end simon;

architecture behaviour of simon is
-- //////// //////// //////// //////// //////// //////// //////// ////////
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
            keyIn: in std_logic_vector((keySegmentLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component;
    
    component messageDecrypter is
        port(
            keyIn: in std_logic_vector((keySegmentLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component; 
    
    -- internal signals
        signal saved_mode: std_logic := '0';
        signal saved_key: std_logic_vector(keyLength-1 downto 0) := (others => '0');
        signal saved_messageIn, saved_messageOut_encrypt, saved_messageOut_decrypt: std_logic_vector(messageLength-1 downto 0) := (others => '0');
        
        signal completeKeys: std_logic_vector((keySegmentLength*maxCryptLoopCount-1) downto 0) := (others => '0');
        signal useKey: std_logic_vector((keySegmentLength-1) downto 0) := (others => '0');
        
        shared variable processCount: integer := 0;
        shared variable inverse_processCount: integer := 0;

begin
-- //////// //////// //////// //////// //////// //////// //////// ////////
	-- connect components
        completekeyExpansion: completeKeyExpander port map(
            Z => selectedZ,
            keyIn => saved_key,
            keysOut => completeKeys
        ); 
        
        encryptMessage: messageEncrypter port map(
            keyIn => useKey,  
            messageIn => saved_messageIn,
            messageOut => saved_messageOut_encrypt
        );
        
        decryptMessage: messageDecrypter port map(
            keyIn => useKey,  
            messageIn => saved_messageIn,
            messageOut => saved_messageOut_decrypt
        );
        
    -- main process
        process(clock) begin if(rising_edge(clock))then
            if(load = '1')then
                processCount := 0;
                saved_mode <= mode;
                saved_key <= keyIn;
                saved_messageIn <= messageIn;
            else
                if(processCount = 0)then
                    if(saved_mode = '0')then    useKey <= completeKeys( (keySegmentLength-1) downto 0 );     
                    else                        useKey <= completeKeys( maxCryptLoopCount*keySegmentLength-1 downto maxCryptLoopCount*keySegmentLength - keySegmentLength ); end if;
                elsif(processCount = maxCryptLoopCount)then
                    if(saved_mode = '0')then    messageOut <= saved_messageOut_encrypt;
                    else                        messageOut <= saved_messageOut_decrypt; end if;
                else
                    if(saved_mode = '0')then    useKey <= completeKeys( (processCount*keySegmentLength + (keySegmentLength-1)) downto (processCount*keySegmentLength) ); 
                                                saved_messageIn <= saved_messageOut_encrypt; 
                    else                        useKey <= completeKeys( (inverse_processCount*keySegmentLength + (keySegmentLength-1)) downto (inverse_processCount*keySegmentLength) ); 
                                                saved_messageIn <= saved_messageOut_decrypt;end if;
                end if;
                
                processCount := processCount + 1; inverse_processCount := maxCryptLoopCount - processCount - 1;
            end if;
        end if; end process;

end behaviour;
