library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; 
use work.printerlib.all;

entity simon_package is
    port(
        control, input: in std_logic_vector(7 downto 0) := (others => '0');
        output: out std_logic_vector(7 downto 0) := (others => '0') 
    );
end simon_package;

architecture behaviour of simon_package is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare constants
    constant messageLength: integer := 128;
    constant keyLength: integer := 256;
    
    -- declare component
    component simon
        port(
            mode: in std_logic;
            keyIn: in std_logic_vector((keyLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component;
    
    -- internal signals
    signal mode_buffer: std_logic;
    signal keyIn_buffer: std_logic_vector((keyLength-1) downto 0);
    signal messageIn_buffer: std_logic_vector((messageLength-1) downto 0);
    signal messageOut_buffer: std_logic_vector((messageLength-1) downto 0);
    
begin
    -- connect component
    mainComponent: simon port map(
        mode => mode_buffer,
        keyIn => keyIn_buffer,
        messageIn => messageIn_buffer,
        messageOut => messageOut_buffer
    );

    -- output switching
		output <= messageOut_buffer( 7   downto 0   ) when control = x"01" else
				  messageOut_buffer( 15  downto 8   ) when control = x"02" else 
				  messageOut_buffer( 23  downto 16  ) when control = x"03" else 
				  messageOut_buffer( 31  downto 24  ) when control = x"04" else
				  messageOut_buffer( 39  downto 32  ) when control = x"05" else 
				  messageOut_buffer( 47  downto 40  ) when control = x"06" else 
				  messageOut_buffer( 55  downto 48  ) when control = x"07" else
				  messageOut_buffer( 63  downto 56  ) when control = x"08" else
				  messageOut_buffer( 71  downto 64  ) when control = x"09" else
				  messageOut_buffer( 79  downto 72  ) when control = x"0a" else 
				  messageOut_buffer( 87  downto 80  ) when control = x"0b" else 
				  messageOut_buffer( 95  downto 88  ) when control = x"0c" else
				  messageOut_buffer( 103 downto 96  ) when control = x"0d" else 
				  messageOut_buffer( 111 downto 104 ) when control = x"0e" else 
				  messageOut_buffer( 119 downto 112 ) when control = x"0f" else
				  messageOut_buffer( 127 downto 120 ) when control = x"10" else
				  x"00";
                  
    -- method mode controls
        mode_buffer <= input(0) when control = x"40";

    -- generate buffer-switch for input
        messageIn_buffer(7   downto 0  ) <= input when control = x"41";
        messageIn_buffer(15  downto 8  ) <= input when control = x"42";
        messageIn_buffer(23  downto 16 ) <= input when control = x"43";
        messageIn_buffer(31  downto 24 ) <= input when control = x"44";
        messageIn_buffer(39  downto 32 ) <= input when control = x"45";
        messageIn_buffer(47  downto 40 ) <= input when control = x"46";
        messageIn_buffer(55  downto 48 ) <= input when control = x"47";
        messageIn_buffer(63  downto 56 ) <= input when control = x"48";
        messageIn_buffer(71  downto 64 ) <= input when control = x"49";
        messageIn_buffer(79  downto 72 ) <= input when control = x"4a";
        messageIn_buffer(87  downto 80 ) <= input when control = x"4b";
        messageIn_buffer(95  downto 88 ) <= input when control = x"4c";
        messageIn_buffer(103 downto 96 ) <= input when control = x"4d";
        messageIn_buffer(111 downto 104) <= input when control = x"4e";
        messageIn_buffer(119 downto 112) <= input when control = x"4f";
        messageIn_buffer(127 downto 120) <= input when control = x"50";
        
    -- generate buffer-switch for key  
        keyIn_buffer(7   downto 0  ) <= input when control = x"81";
        keyIn_buffer(15  downto 8  ) <= input when control = x"82";
        keyIn_buffer(23  downto 16 ) <= input when control = x"83";
        keyIn_buffer(31  downto 24 ) <= input when control = x"84";
        keyIn_buffer(39  downto 32 ) <= input when control = x"85";
        keyIn_buffer(47  downto 40 ) <= input when control = x"86";
        keyIn_buffer(55  downto 48 ) <= input when control = x"87";
        keyIn_buffer(63  downto 56 ) <= input when control = x"88"; 
        keyIn_buffer(71  downto 64 ) <= input when control = x"89";
        keyIn_buffer(79  downto 72 ) <= input when control = x"8a";
        keyIn_buffer(87  downto 80 ) <= input when control = x"8b";
        keyIn_buffer(95  downto 88 ) <= input when control = x"8c";
        keyIn_buffer(103 downto 96 ) <= input when control = x"8d";
        keyIn_buffer(111 downto 104) <= input when control = x"8e";
        keyIn_buffer(119 downto 112) <= input when control = x"8f";
        keyIn_buffer(127 downto 120) <= input when control = x"90";
        keyIn_buffer(135 downto 128) <= input when control = x"91";
        keyIn_buffer(143 downto 136) <= input when control = x"92";
        keyIn_buffer(151 downto 144) <= input when control = x"93";
        keyIn_buffer(159 downto 152) <= input when control = x"94";
        keyIn_buffer(167 downto 160) <= input when control = x"95";
        keyIn_buffer(175 downto 168) <= input when control = x"96";
        keyIn_buffer(183 downto 176) <= input when control = x"97";
        keyIn_buffer(191 downto 184) <= input when control = x"98"; 
        keyIn_buffer(199 downto 192) <= input when control = x"99";
        keyIn_buffer(207 downto 200) <= input when control = x"9a";
        keyIn_buffer(215 downto 208) <= input when control = x"9b";
        keyIn_buffer(223 downto 216) <= input when control = x"9c";
        keyIn_buffer(231 downto 224) <= input when control = x"9d";
        keyIn_buffer(239 downto 232) <= input when control = x"9e";
        keyIn_buffer(247 downto 240) <= input when control = x"9f";
        keyIn_buffer(255 downto 248) <= input when control = x"a0";

end behaviour;