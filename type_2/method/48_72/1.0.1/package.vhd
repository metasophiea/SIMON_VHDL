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
    constant messageLength: integer := 48;
    constant keyLength: integer := 72;

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
        
end behaviour;