library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity packageTester is
end packageTester;

architecture behaviour of packageTester is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare component
    component simon_package is
        port(
            control, input: in std_logic_vector(7 downto 0) := (others => '0');
            output: out std_logic_vector(7 downto 0) := (others => '0')
        );
    end component;

    -- internal signals 
        signal tester_control: std_logic_vector(7 downto 0) := (others => '0');
        signal tester_input: std_logic_vector(7 downto 0) := (others => '0');
        signal tester_output: std_logic_vector(7 downto 0) := (others => '0');
        
    procedure methodTest(signal control, input: out std_logic_vector; message, key: std_logic_vector; mode: std_logic) is begin
        --set message -> 6565 6877
            for a in 0 to (messageLength/8)-1 loop
                control <= std_logic_vector(to_unsigned((64+a+1),8)); 
                input <= message(   messageLength-((a+1)*8)     to    messageLength-((a)*8)-1     ); 
                wait for 1 ns; 
            end loop;
            
        -- wait 
            wait for 10 ns;     
            
        --set key -> 1918 1110 0908 0100
            for a in 0 to (keyLength/8)-1 loop
                control <= std_logic_vector(to_unsigned((80+a+1),8)); 
                input <= key(   keyLength-((a+1)*8)     to    keyLength-((a)*8)-1     ); 
                wait for 1 ns; 
            end loop;  

        -- wait 
            wait for 10 ns;
            
        --set mode and load           
            control <= "11000000";
                input(0) <= mode; input(5) <= '1'; wait for 1 ns;   
                input(0) <= mode; input(5) <= '0'; wait for 1 ns;   
            control <= "00000000";

        -- wait 
            wait for 10 ns;
            
        -- process
            for a in 0 to maxCryptLoopCount loop
                control(7) <= '1'; wait for 1 ns; control(7) <= '0'; wait for 1 ns;
            end loop;
            
        -- wait 
            wait for 10 ns;           
            
        --read message
            for a in 0 to (messageLength/8)-1 loop
                control <= std_logic_vector(to_unsigned((a+1),8)); 
                wait for 1 ns; 
            end loop;
            
    end procedure;

-- //////// //////// //////// //////// //////// //////// //////// ////////
    begin
    -- connect component
        mainComponent: simon_package port map(
            control => tester_control,
            input => tester_input,
            output => tester_output
        );

    -- run tests
        process begin
        
            case(method) is
                when 0 => 
                    methodTest(tester_control, tester_input, x"65656877", x"1918111009080100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"c69be9bb", x"1918111009080100", '1'); wait for 20 ns; 
                when 1 => 
                    methodTest(tester_control, tester_input, x"6120676e696c", x"1211100a0908020100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"dae5ac292cac", x"1211100a0908020100", '1'); wait for 20 ns; 
                when 2 => 
                    methodTest(tester_control, tester_input, x"72696320646e", x"1a19181211100a0908020100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"6e06a5acf156", x"1a19181211100a0908020100", '1'); wait for 20 ns; 
                when 3 => 
                    methodTest(tester_control, tester_input, x"6f7220676e696c63", x"131211100b0a090803020100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"5ca2e27f111a8fc8", x"131211100b0a090803020100", '1'); wait for 20 ns; 
                when 4 => 
                    methodTest(tester_control, tester_input, x"656b696c20646e75", x"1b1a1918131211100b0a090803020100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"44c8fc20b9dfa07a", x"1b1a1918131211100b0a090803020100", '1'); wait for 20 ns; 
                when 5 => 
                    methodTest(tester_control, tester_input, x"2072616c6c69702065687420", x"0d0c0b0a0908050403020100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"602807a462b469063d8ff082", x"0d0c0b0a0908050403020100", '1'); wait for 20 ns; 
                when 6 => 
                    methodTest(tester_control, tester_input, x"74616874207473756420666f", x"1514131211100d0c0b0a0908050403020100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"ecad1c6c451e3f59c5db1ae9", x"1514131211100d0c0b0a0908050403020100", '1'); wait for 20 ns; 
                when 7 => 
                    methodTest(tester_control, tester_input, x"63736564207372656c6c657661727420", x"0f0e0d0c0b0a09080706050403020100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"49681b1e1e54fe3f65aa832af84e0bbc", x"0f0e0d0c0b0a09080706050403020100", '1'); wait for 20 ns; 
                when 8 => 
                    methodTest(tester_control, tester_input, x"206572656874206e6568772065626972", x"17161514131211100f0e0d0c0b0a09080706050403020100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"c4ac61effcdc0d4f6c9c8d6e2597b85b", x"17161514131211100f0e0d0c0b0a09080706050403020100", '1'); wait for 20 ns; 
                when 9 => 
                    methodTest(tester_control, tester_input, x"74206e69206d6f6f6d69732061207369", x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100", '0'); wait for 20 ns; 
                    methodTest(tester_control, tester_input, x"8d2b5579afc8a3a03bf72a87efe7b868", x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100", '1'); wait for 20 ns; 
                when others =>
            end case;

            --timeout
            wait for 1000 ms;    
        end process;          

end behaviour;