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
				mode: in std_logic;
				keyIn: in std_logic_vector(keyLength-1 downto 0);
				messageIn: in std_logic_vector(messageLength-1 downto 0);
				messageOut: out std_logic_vector(messageLength-1 downto 0) 
			);
		end component;
    
    -- internal signals
        signal mode_buffer: std_logic := '0';
        signal keyIn_buffer: std_logic_vector(keyLength-1 downto 0) := (others => '0');
        signal messageIn_buffer, messageOut_connections: std_logic_vector(messageLength-1 downto 0) := (others => '0');
begin
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- connect component
        mainComponent: simon port map(
            mode => mode_buffer,
            keyIn => keyIn_buffer,
            messageIn => messageIn_buffer,
            messageOut => messageOut_connections
        );
             
    -- output switching
        outputBuffer_generation_0: if(method = 0)generate
            output <=   messageOut_connections( 7   downto 0   ) when control = x"01" else
                        messageOut_connections( 15  downto 8   ) when control = x"02" else 
                        messageOut_connections( 23  downto 16  ) when control = x"03" else 
                        messageOut_connections( 31  downto 24  ) when control = x"04" else
                        x"00";
        end generate;
        
        outputBuffer_generation_1: if(method = 1 or method = 2)generate
            output <=   messageOut_connections( 7   downto 0   ) when control = x"01" else
                        messageOut_connections( 15  downto 8   ) when control = x"02" else
                        messageOut_connections( 23  downto 16  ) when control = x"03" else
                        messageOut_connections( 31  downto 24  ) when control = x"04" else
                        messageOut_connections( 39  downto 32  ) when control = x"05" else
                        messageOut_connections( 47  downto 40  ) when control = x"06" else
                        x"00";
        end generate;    
        
        outputBuffer_generation_2: if(method = 3 or method = 4)generate
            output <=   messageOut_connections( 7   downto 0   ) when control = x"01" else
                        messageOut_connections( 15  downto 8   ) when control = x"02" else
                        messageOut_connections( 23  downto 16  ) when control = x"03" else
                        messageOut_connections( 31  downto 24  ) when control = x"04" else
                        messageOut_connections( 39  downto 32  ) when control = x"05" else
                        messageOut_connections( 47  downto 40  ) when control = x"06" else
                        messageOut_connections( 55  downto 48  ) when control = x"07" else
                        x"00";
        end generate;
        
        outputBuffer_generation_3: if(method = 5 or method = 6)generate
            output <=   messageOut_connections( 7   downto 0   ) when control = x"01" else
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
                        x"00";
        end generate;
        
        outputBuffer_generation_4: if(method = 7 or method = 8 or method = 9)generate
            output <=   messageOut_connections( 7   downto 0   ) when control = x"01" else
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
        end generate;    
     
    -- method mode controls
        mode_buffer <= input(0) when control = x"40";

    -- generate buffer-switch for input
        inputBuffer_generation:for a in 0 to ((messageLength/8)-1) generate
            messageIn_buffer(((a*8)+7) downto a*8) <= input when control = "01" & std_logic_vector(to_unsigned((a+1),6));
        end generate; 
     
    -- generate buffer-switch for key  
        keyInBuffer_generation:for a in 0 to ((keyLength/8)-1) generate
            keyIn_buffer(((a*8)+7) downto a*8) <= input when control = "01" & std_logic_vector(to_unsigned((16+a+1),6));
        end generate; 
     
end behaviour;