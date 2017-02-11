library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity simon_package is
    port(
        control, input: in std_logic_vector(7 downto 0) := (others => '0');
        output: out std_logic_vector(7 downto 0) := (others => '0')
    );
end simon_package;

architecture behaviour of simon_package is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare components
    component simon
        port(
            mode: in std_logic := '0';
            method: in std_logic_vector(3 downto 0) := (others => '0');
            keyIn: in std_logic_vector(255 downto 0) := (others => '0');
            messageIn: in std_logic_vector(127 downto 0) := (others => '0');
            messageOut: out std_logic_vector(127 downto 0) := (others => '0')
        );
    end component;
    
    -- internal signals
        signal mode_buffer: std_logic := '0';
        signal method_buffer: std_logic_vector(3 downto 0) := (others => '0');
        signal keyIn_buffer: std_logic_vector(255 downto 0) := (others => '0');
        signal messageIn_buffer, messageOut_connections: std_logic_vector(127 downto 0) := (others => '0');
        
        signal control_connector: std_logic_vector(7 downto 0) := (others => '0');
begin
    -- connect component
        mainComponent: simon port map(
            mode => mode_buffer,
            method => method_buffer,
            keyIn => keyIn_buffer,
            messageIn => messageIn_buffer,
            messageOut => messageOut_connections
        );
        
    -- method mode controls
        mode_buffer <= input(0) when control = x"40";
        method_buffer <= input(4 downto 1) when control = x"40";

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
        keyIn_buffer(7   downto 0  ) <= input when control = x"51";
        keyIn_buffer(15  downto 8  ) <= input when control = x"52";
        keyIn_buffer(23  downto 16 ) <= input when control = x"53";
        keyIn_buffer(31  downto 24 ) <= input when control = x"54";
        keyIn_buffer(39  downto 32 ) <= input when control = x"55";
        keyIn_buffer(47  downto 40 ) <= input when control = x"56";
        keyIn_buffer(55  downto 48 ) <= input when control = x"57";
        keyIn_buffer(63  downto 56 ) <= input when control = x"58"; 
        keyIn_buffer(71  downto 64 ) <= input when control = x"59";
        keyIn_buffer(79  downto 72 ) <= input when control = x"5a";
        keyIn_buffer(87  downto 80 ) <= input when control = x"5b";
        keyIn_buffer(95  downto 88 ) <= input when control = x"5c";
        keyIn_buffer(103 downto 96 ) <= input when control = x"5d";
        keyIn_buffer(111 downto 104) <= input when control = x"5e";
        keyIn_buffer(119 downto 112) <= input when control = x"5f";
        keyIn_buffer(127 downto 120) <= input when control = x"60";
        keyIn_buffer(135 downto 128) <= input when control = x"61";
        keyIn_buffer(143 downto 136) <= input when control = x"62";
        keyIn_buffer(151 downto 144) <= input when control = x"63";
        keyIn_buffer(159 downto 152) <= input when control = x"64";
        keyIn_buffer(167 downto 160) <= input when control = x"65";
        keyIn_buffer(175 downto 168) <= input when control = x"66";
        keyIn_buffer(183 downto 176) <= input when control = x"67";
        keyIn_buffer(191 downto 184) <= input when control = x"68"; 
        keyIn_buffer(199 downto 192) <= input when control = x"69";
        keyIn_buffer(207 downto 200) <= input when control = x"6a";
        keyIn_buffer(215 downto 208) <= input when control = x"6b";
        keyIn_buffer(223 downto 216) <= input when control = x"6c";
        keyIn_buffer(231 downto 224) <= input when control = x"6d";
        keyIn_buffer(239 downto 232) <= input when control = x"6e";
        keyIn_buffer(247 downto 240) <= input when control = x"6f";
        keyIn_buffer(255 downto 248) <= input when control = x"70";
        
    -- output switching
        output <= messageOut_connections( 7   downto 0   ) when control = x"01" else
                  messageOut_connections( 15  downto 8   ) when control = x"02" else 
                  messageOut_connections( 23  downto 16  ) when control = x"03" else 
                  messageOut_connections( 31  downto 24  ) when control = x"04" else
                  messageOut_connections( 39  downto 32  ) when control = x"05" else 
                  messageOut_connections( 47  downto 40  ) when control = x"06" else 
                  messageOut_connections( 55  downto 48  ) when control = x"07" else
                  messageOut_connections( 63  downto 56  ) when control = x"08" else
                  messageOut_connections( 71  downto 64  ) when control = x"09" else
                  messageOut_connections( 79  downto 72  ) when control = x"0a" else 
                  messageOut_connections( 87  downto 80  ) when control = x"0b" else 
                  messageOut_connections( 95  downto 88  ) when control = x"0c" else
                  messageOut_connections( 103 downto 96  ) when control = x"0d" else 
                  messageOut_connections( 111 downto 104 ) when control = x"0e" else 
                  messageOut_connections( 119 downto 112 ) when control = x"0f" else
                  messageOut_connections( 127 downto 120 ) when control = x"10" else
                  x"00";
        
end behaviour;