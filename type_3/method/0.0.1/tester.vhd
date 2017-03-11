--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
--use work.constants.all;

--entity tester is
--end tester;

--architecture behaviour of tester is
---- //////// //////// //////// //////// //////// //////// //////// ////////
--    -- declare component
--    component simon
--        port(
--            mode, clock, load: in std_logic;
--            keyIn: in std_logic_vector(keyLength-1 downto 0);
--            messageIn: in std_logic_vector(messageLength-1 downto 0);
--            messageOut: out std_logic_vector(messageLength-1 downto 0) 
--        );
--    end component;

--    -- internal signals 
--    signal tester_mode, tester_clock, tester_load: std_logic := '0';
--    signal tester_keyIn: std_logic_vector(keyLength-1 downto 0) := (others => '0');
--    signal tester_messageIn: std_logic_vector(messageLength-1 downto 0) := (others => '0');
--    signal tester_messageOut: std_logic_vector(messageLength-1 downto 0) := (others => '0');

---- //////// //////// //////// //////// //////// //////// //////// ////////
--    begin
--    -- connect component
--        mainComponent: simon port map(
--            mode => tester_mode, 
--			clock => tester_clock,
--			load => tester_load,
--            keyIn => tester_keyIn,
--            messageIn => tester_messageIn,
--            messageOut => tester_messageOut
--        );

--    -- run tests
--        process begin
--            if(method = 0)then
--                tester_mode <= '0';
--                tester_keyIn <= x"1918111009080100";
--                tester_messageIn <= x"65656877";
--                tester_load <= '1'; wait for 1 ns; 
--                    tester_clock <= '1'; wait for 1 ns; 
--                    tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 32 loop
--                    tester_clock <= '1'; wait for 1ns;
--                    tester_clock <= '0'; wait for 1ns;
--                end loop;
                
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"1918111009080100";
--                tester_messageIn <= x"c69be9bb";
--                tester_load <= '1'; wait for 1 ns; 
--                    tester_clock <= '1'; wait for 1 ns; 
--                    tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 32 loop
--                    tester_clock <= '1'; wait for 1ns;
--                    tester_clock <= '0'; wait for 1ns;
--                end loop;
                
--                wait for 10 ns; 
--            end if;
                
--            if(method = 1)then
--                tester_mode <= '0';
--                tester_keyIn <= x"1211100a0908020100";
--                tester_messageIn <= x"6120676e696c";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 36 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                              
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"1211100a0908020100";
--                tester_messageIn <= x"dae5ac292cac";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 36 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                              
--                wait for 10 ns;     
--            end if;
                
--            if(method = 2)then
--                tester_mode <= '0';
--                tester_keyIn <= x"1a19181211100a0908020100";
--                tester_messageIn <= x"72696320646e";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 36 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                              
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"1a19181211100a0908020100";
--                tester_messageIn <= x"6e06a5acf156";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 36 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                              
--                wait for 10 ns; 
--            end if;
                    
--            if(method = 3)then
--                tester_mode <= '0';
--                tester_keyIn <= x"131211100b0a090803020100";
--                tester_messageIn <= x"6f7220676e696c63";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 42 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                         
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"131211100b0a090803020100";
--                tester_messageIn <= x"5ca2e27f111a8fc8";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 42 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                         
--                wait for 10 ns; 
--            end if;
                    
--            if(method = 4)then
--                tester_mode <= '0';
--                tester_keyIn <= x"1b1a1918131211100b0a090803020100";      
--                tester_messageIn <= x"656b696c20646e75"; 
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 44 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                              
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"1b1a1918131211100b0a090803020100";
--                tester_messageIn <= x"44c8fc20b9dfa07a"; 
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 44 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                         
--                wait for 10 ns; 
--            end if;
                    
--            if(method = 5)then
--                tester_mode <= '0';
--                tester_keyIn <= x"0d0c0b0a0908050403020100";
--                tester_messageIn <= x"2072616c6c69702065687420";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 52 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                              
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"0d0c0b0a0908050403020100";
--                tester_messageIn <= x"602807a462b469063d8ff082";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 52 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                         
--                wait for 10 ns; 
--            end if;
                    
--            if(method = 6)then
--                tester_mode <= '0';
--                tester_keyIn <= x"1514131211100d0c0b0a0908050403020100";
--                tester_messageIn <= x"74616874207473756420666f";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 54 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                              
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"1514131211100d0c0b0a0908050403020100";
--                tester_messageIn <= x"ecad1c6c451e3f59c5db1ae9";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 54 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                         
--                wait for 10 ns; 
--            end if;
                    
--            if(method = 7)then
--                tester_mode <= '0';
--                tester_keyIn <= x"0f0e0d0c0b0a09080706050403020100";
--                tester_messageIn <= x"63736564207372656c6c657661727420";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 68 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                              
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"0f0e0d0c0b0a09080706050403020100";
--                tester_messageIn <= x"49681b1e1e54fe3f65aa832af84e0bbc";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 68 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                         
--                wait for 10 ns; 
--            end if;
                    
--            if(method = 8)then
--                tester_mode <= '0';
--                tester_keyIn <= x"17161514131211100f0e0d0c0b0a09080706050403020100";
--                tester_messageIn <= x"206572656874206e6568772065626972";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 69 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                              
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"17161514131211100f0e0d0c0b0a09080706050403020100";
--                tester_messageIn <= x"c4ac61effcdc0d4f6c9c8d6e2597b85b";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 69 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                         
--                wait for 10 ns; 
--            end if;
                    
--            if(method = 9)then
--                tester_mode <= '0';
--                tester_keyIn <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
--                tester_messageIn <= x"74206e69206d6f6f6d69732061207369";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 72 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                              
--                wait for 10 ns; 
                
--                tester_mode <= '1';
--                tester_keyIn <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
--                tester_messageIn <= x"8d2b5579afc8a3a03bf72a87efe7b868";
--                tester_load <= '1'; wait for 1 ns; 
--                  tester_clock <= '1'; wait for 1 ns; 
--                  tester_clock <= '0'; wait for 1 ns;
--                tester_load <= '0';
--                for a in 0 to 72 loop
--                  tester_clock <= '1'; wait for 1ns;
--                  tester_clock <= '0'; wait for 1ns;
--                end loop;
                                         
--                wait for 10 ns; 
--            end if;
                    
--            --timeout
--            wait for 1000 ms;    
--        end process;          

--end behaviour;