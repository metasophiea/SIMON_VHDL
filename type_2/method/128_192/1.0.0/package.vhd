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
    -- declare constants
    constant messageLength: integer := 128;
    constant keyLength: integer := 192;

    -- declare components
    component simon
        port(
            mode, clock: in std_logic := '0';
            keyIn: in std_logic_vector((keyLength-1) downto 0) := (others => '0');
            messageIn: in std_logic_vector((messageLength-1) downto 0) := (others => '0');
            messageOut: out std_logic_vector((messageLength-1) downto 0) := (others => '0')
        );
    end component;
    
    -- internal signals
        signal mode_buffer, clock_buffer: std_logic := '0';
        signal keyIn_buffer: std_logic_vector((keyLength-1) downto 0) := (others => '0');
        signal messageIn_buffer, messageOut_connections: std_logic_vector((messageLength-1) downto 0) := (others => '0');
        
begin
    -- connect component
        mainComponent: simon port map(
            mode => mode_buffer,
            clock => clock_buffer,
            keyIn => keyIn_buffer,
            messageIn => messageIn_buffer,
            messageOut => messageOut_connections
        );
        
    -- clock input    
        clock_buffer <= control(7);
        
    -- output switching
        output <= messageOut_connections( 7   downto 0   ) when control(6 downto 0) = "0000001" else
                  messageOut_connections( 15  downto 8   ) when control(6 downto 0) = "0000010" else 
                  messageOut_connections( 23  downto 16  ) when control(6 downto 0) = "0000011" else 
                  messageOut_connections( 31  downto 24  ) when control(6 downto 0) = "0000100" else
                  messageOut_connections( 39  downto 32  ) when control(6 downto 0) = "0000101" else 
                  messageOut_connections( 47  downto 40  ) when control(6 downto 0) = "0000110" else 
                  messageOut_connections( 55  downto 48  ) when control(6 downto 0) = "0000111" else
                  messageOut_connections( 63  downto 56  ) when control(6 downto 0) = "0001000" else
                  messageOut_connections( 71  downto 64  ) when control(6 downto 0) = "0001001" else
                  messageOut_connections( 79  downto 72  ) when control(6 downto 0) = "0001010" else 
                  messageOut_connections( 87  downto 80  ) when control(6 downto 0) = "0001011" else 
                  messageOut_connections( 95  downto 88  ) when control(6 downto 0) = "0001100" else
                  messageOut_connections( 103 downto 96  ) when control(6 downto 0) = "0001101" else 
                  messageOut_connections( 111 downto 104 ) when control(6 downto 0) = "0001110" else 
                  messageOut_connections( 119 downto 112 ) when control(6 downto 0) = "0001111" else
                  messageOut_connections( 127 downto 120 ) when control(6 downto 0) = "0010000" else
                  x"00";
        
    -- method mode controls
        mode_buffer <= input(0) when control(6 downto 0) = "1000000";

    -- generate buffer-switch for input
        messageIn_buffer(7   downto 0  ) <= input when control(6 downto 0) = "1000001";
        messageIn_buffer(15  downto 8  ) <= input when control(6 downto 0) = "1000010";
        messageIn_buffer(23  downto 16 ) <= input when control(6 downto 0) = "1000011";
        messageIn_buffer(31  downto 24 ) <= input when control(6 downto 0) = "1000100";
        messageIn_buffer(39  downto 32 ) <= input when control(6 downto 0) = "1000101";
        messageIn_buffer(47  downto 40 ) <= input when control(6 downto 0) = "1000110";
        messageIn_buffer(55  downto 48 ) <= input when control(6 downto 0) = "1000111";
        messageIn_buffer(63  downto 56 ) <= input when control(6 downto 0) = "1001000";
        messageIn_buffer(71  downto 64 ) <= input when control(6 downto 0) = "1001001";
        messageIn_buffer(79  downto 72 ) <= input when control(6 downto 0) = "1001010";
        messageIn_buffer(87  downto 80 ) <= input when control(6 downto 0) = "1001011";
        messageIn_buffer(95  downto 88 ) <= input when control(6 downto 0) = "1001100";
        messageIn_buffer(103 downto 96 ) <= input when control(6 downto 0) = "1001101";
        messageIn_buffer(111 downto 104) <= input when control(6 downto 0) = "1001110";
        messageIn_buffer(119 downto 112) <= input when control(6 downto 0) = "1001111";
        messageIn_buffer(127 downto 120) <= input when control(6 downto 0) = "1010000";
        
    -- generate buffer-switch for key  
        keyIn_buffer(7   downto 0  ) <= input when control(6 downto 0) = "1010001";
        keyIn_buffer(15  downto 8  ) <= input when control(6 downto 0) = "1010010";
        keyIn_buffer(23  downto 16 ) <= input when control(6 downto 0) = "1010011";
        keyIn_buffer(31  downto 24 ) <= input when control(6 downto 0) = "1010100";
        keyIn_buffer(39  downto 32 ) <= input when control(6 downto 0) = "1010101";
        keyIn_buffer(47  downto 40 ) <= input when control(6 downto 0) = "1010110";
        keyIn_buffer(55  downto 48 ) <= input when control(6 downto 0) = "1010111";
        keyIn_buffer(63  downto 56 ) <= input when control(6 downto 0) = "1011000"; 
        keyIn_buffer(71  downto 64 ) <= input when control(6 downto 0) = "1011001";
        keyIn_buffer(79  downto 72 ) <= input when control(6 downto 0) = "1011010";
        keyIn_buffer(87  downto 80 ) <= input when control(6 downto 0) = "1011011";
        keyIn_buffer(95  downto 88 ) <= input when control(6 downto 0) = "1011100";
        keyIn_buffer(103 downto 96 ) <= input when control(6 downto 0) = "1011101";
        keyIn_buffer(111 downto 104) <= input when control(6 downto 0) = "1011110";
        keyIn_buffer(119 downto 112) <= input when control(6 downto 0) = "1011111";
        keyIn_buffer(127 downto 120) <= input when control(6 downto 0) = "1100000";
        keyIn_buffer(135 downto 128) <= input when control(6 downto 0) = "1100001";
        keyIn_buffer(143 downto 136) <= input when control(6 downto 0) = "1100010";
        keyIn_buffer(151 downto 144) <= input when control(6 downto 0) = "1100011";
        keyIn_buffer(159 downto 152) <= input when control(6 downto 0) = "1100100";
        keyIn_buffer(167 downto 160) <= input when control(6 downto 0) = "1100101";
        keyIn_buffer(175 downto 168) <= input when control(6 downto 0) = "1100110";
        keyIn_buffer(183 downto 176) <= input when control(6 downto 0) = "1100111";
        keyIn_buffer(191 downto 184) <= input when control(6 downto 0) = "1101000";
        
end behaviour;