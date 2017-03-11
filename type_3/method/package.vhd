library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity simon_package is
    port(
        control, input: in std_logic_vector(7 downto 0) := (others => '0');
        output: out std_logic_vector(7 downto 0) := (others => '0')
    );
end simon_package;

architecture behaviour of simon_package is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare component
    component simon
        port(
            mode, clock, load: in std_logic;
            keyIn: in std_logic_vector(keyLength-1 downto 0);
            messageIn: in std_logic_vector(messageLength-1 downto 0);
            messageOut: out std_logic_vector(messageLength-1 downto 0) 
        );
    end component;
    
    -- internal signals
        signal mode_buffer, clock_buffer, load_connect: std_logic := '0';
        signal keyIn_buffer: std_logic_vector(keyLength-1 downto 0) := (others => '0');
        signal messageIn_buffer, messageOut_connections: std_logic_vector(messageLength-1 downto 0) := (others => '0');
begin
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- connect component
        mainComponent: simon port map(
            mode => mode_buffer,
            clock => clock_buffer,
            load => load_connect,
            keyIn => keyIn_buffer,
            messageIn => messageIn_buffer,
            messageOut => messageOut_connections
        );
   -- clock input    
        clock_buffer <= control(7);
             
    -- output switching
        outputBuffer_generation_0: if(method = 0)generate
            output <=   messageOut_connections( 7   downto 0   ) when control(6 downto 0) = "0000001" else
                        messageOut_connections( 15  downto 8   ) when control(6 downto 0) = "0000010" else 
                        messageOut_connections( 23  downto 16  ) when control(6 downto 0) = "0000011" else 
                        messageOut_connections( 31  downto 24  ) when control(6 downto 0) = "0000100" else
                        x"00";
        end generate;
        
        outputBuffer_generation_1: if(method = 1 or method = 2)generate
            output <=   messageOut_connections( 7   downto 0   ) when control(6 downto 0) = "0000001" else
                        messageOut_connections( 15  downto 8   ) when control(6 downto 0) = "0000010" else 
                        messageOut_connections( 23  downto 16  ) when control(6 downto 0) = "0000011" else 
                        messageOut_connections( 31  downto 24  ) when control(6 downto 0) = "0000100" else
                        messageOut_connections( 39  downto 32  ) when control(6 downto 0) = "0000101" else 
                        messageOut_connections( 47  downto 40  ) when control(6 downto 0) = "0000110" else
                        x"00";
        end generate;    
        
        outputBuffer_generation_2: if(method = 3 or method = 4)generate
            output <=   messageOut_connections( 7   downto 0   ) when control(6 downto 0) = "0000001" else
                        messageOut_connections( 15  downto 8   ) when control(6 downto 0) = "0000010" else 
                        messageOut_connections( 23  downto 16  ) when control(6 downto 0) = "0000011" else
                        messageOut_connections( 31  downto 24  ) when control(6 downto 0) = "0000100" else 
                        messageOut_connections( 39  downto 32  ) when control(6 downto 0) = "0000101" else
                        messageOut_connections( 47  downto 40  ) when control(6 downto 0) = "0000110" else 
                        messageOut_connections( 55  downto 48  ) when control(6 downto 0) = "0000111" else
                        messageOut_connections( 63  downto 56  ) when control(6 downto 0) = "0001000" else 
                        x"00";
        end generate;
        
        outputBuffer_generation_3: if(method = 5 or method = 6)generate
            output <=   messageOut_connections( 7   downto 0   ) when control(6 downto 0) = "0000001" else
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
                        x"00";
        end generate;
        
        outputBuffer_generation_4: if(method = 7 or method = 8 or method = 9)generate
            output <=   messageOut_connections( 7   downto 0   ) when control(6 downto 0) = "0000001" else
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
        end generate;    
     
    -- method mode controls
        mode_buffer <= input(0) when control(6 downto 0) = "1000000";
        load_connect <= input(5) when control(6 downto 0) = "1000000" else '0';

    -- generate buffer-switch for input
        inputBuffer_generation:for a in 0 to ((messageLength/8)-1) generate
            messageIn_buffer(((a*8)+7) downto a*8) <= input when control(6 downto 0) = "1" & std_logic_vector(to_unsigned((a+1),6));
        end generate; 
     
    -- generate buffer-switch for key  
        keyInBuffer_generation:for a in 0 to ((keyLength/8)-1) generate
            keyIn_buffer(((a*8)+7) downto a*8) <= input when control(6 downto 0) = "1" & std_logic_vector(to_unsigned((16+a+1),6));
        end generate; 
     
end behaviour;
