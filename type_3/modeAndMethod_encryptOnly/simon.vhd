library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity simon is
    port(
        clock, load: in std_logic;
        keyIn: in std_logic_vector(keyLength-1 downto 0);
        messageIn: in std_logic_vector(messageLength-1 downto 0);
        messageOut: out std_logic_vector(messageLength-1 downto 0) 
    );
end simon;

architecture behaviour of simon is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare components
        component keyExpander
            port(
                Z: in std_logic_vector(61 downto 0);
                keyIn: in std_logic_vector((keyLength-1) downto 0);
                keyOut: out std_logic_vector((keyLength-1) downto 0);
                returnZ: out std_logic_vector(61 downto 0)
            );
        end component;
    
        component messageEncrypter is
            port(
                keyIn: in std_logic_vector((keySegmentLength-1) downto 0);
                messageIn: in std_logic_vector((messageLength-1) downto 0);
                messageOut: out std_logic_vector((messageLength-1) downto 0)
            );
        end component;
        
    -- internal signals        
        signal morphing_Z_in, morphing_Z_out: std_logic_vector(61 downto 0) := (others => '0');
        signal morphing_key_in, morphing_key_out: std_logic_vector(keyLength-1 downto 0) := (others => '0');
        signal morphing_message_in, morphing_message_out:  std_logic_vector(messageLength-1 downto 0) := (others => '0');
        
        shared variable processCount: integer := 0;
        
begin
-- //////// //////// //////// //////// //////// //////// //////// ////////
	-- connect components
        keyExpansion: keyExpander port map(
            Z => morphing_Z_in,
            returnZ => morphing_Z_out,
            keyIn => morphing_key_in,
            keyOut => morphing_key_out
        ); 
	
        encryptMessage: messageEncrypter port map(
            keyIn => morphing_key_in( (keySegmentLength-1) downto 0 ),  
            messageIn => morphing_message_in,
            messageOut => morphing_message_out
        );
	
    -- main process
        process(clock) begin if(rising_edge(clock))then
            if(load = '1')then
                processCount := 0;
                morphing_Z_in <= selectedZ;
                morphing_key_in <= keyIn;
                morphing_message_in <= messageIn;
            else
                if(processCount = maxCryptLoopCount-1)then
                    messageOut <= morphing_message_out;
                else
                    morphing_Z_in <= morphing_Z_out;
                    morphing_key_in <= morphing_key_out;
                    morphing_message_in <= morphing_message_out;
                end if;
                
                processCount := processCount + 1;
            end if;
        end if; end process;
        
end behaviour;