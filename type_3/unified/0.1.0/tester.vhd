library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; 
use work.printerlib.all;

entity tester is
end tester;

architecture behaviour of tester is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare component
    component simon
        port(
            mode, clock, load: in std_logic;
            method: in std_logic_vector(3 downto 0);
            keyIn: in std_logic_vector(255 downto 0);
            messageIn: in std_logic_vector(127 downto 0);
            messageOut: out std_logic_vector(127 downto 0)
        );
    end component;

    -- internal signals 
    signal tester_mode, tester_clock, tester_load: std_logic := '0';
    signal tester_method: std_logic_vector(3 downto 0) := (others => '0');
    signal tester_keyIn: std_logic_vector(255 downto 0) := (others => '0');
    signal tester_messageIn: std_logic_vector(127 downto 0) := (others => '0');
    signal tester_messageOut: std_logic_vector(127 downto 0) := (others => '0');

-- //////// //////// //////// //////// //////// //////// //////// ////////
    begin
    -- connect component
        mainComponent: simon port map(
            mode => tester_mode, 
			clock => tester_clock,
			load => tester_load,
            method => tester_method,
            keyIn => tester_keyIn,
            messageIn => tester_messageIn,
            messageOut => tester_messageOut
        );

    -- run tests
        process begin
            tester_mode <= '0';
            tester_method <= x"0";
            tester_keyIn <= x"0000000000000000000000000000000000000000000000001918111009080100";
            tester_messageIn <= x"00000000000000000000000065656877";
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 32 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
            
            wait for 10 ns; 
            

            tester_mode <= '0';
            tester_method <= x"1";
            tester_keyIn <= x"00000000000000000000000000000000000000000000001211100a0908020100";
            tester_messageIn <= x"000000000000000000006120676e696c";
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 36 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
                            
            wait for 10 ns; 

            tester_mode <= '0';
            tester_method <= x"2";
            tester_keyIn <= x"00000000000000000000000000000000000000001a19181211100a0908020100";
            tester_messageIn <= x"0000000000000000000072696320646e";
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 36 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
                            
            wait for 10 ns; 

            tester_mode <= '0';
            tester_method <= x"3";
            tester_keyIn <= x"0000000000000000000000000000000000000000131211100b0a090803020100";
            tester_messageIn <= x"00000000000000006f7220676e696c63";
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 42 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
                                            
            wait for 10 ns; 

            tester_mode <= '0';
            tester_method <= x"4";
            tester_keyIn <= x"000000000000000000000000000000001b1a1918131211100b0a090803020100";      
            tester_messageIn <= x"0000000000000000656b696c20646e75"; 
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 44 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
                                            
            wait for 10 ns; 
            
            tester_mode <= '0';
            tester_method <= x"5";
            tester_keyIn <= x"00000000000000000000000000000000000000000d0c0b0a0908050403020100";
            tester_messageIn <= x"000000002072616c6c69702065687420";
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 52 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
                                            
            wait for 10 ns; 

            tester_mode <= '0';
            tester_method <= x"6";
            tester_keyIn <= x"00000000000000000000000000001514131211100d0c0b0a0908050403020100";
            tester_messageIn <= x"0000000074616874207473756420666f";
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 54 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
                                            
            wait for 10 ns; 
            
            tester_mode <= '0';
            tester_method <= x"7";
            tester_keyIn <= x"000000000000000000000000000000000f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"63736564207372656c6c657661727420";
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 68 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
                                            
            wait for 10 ns; 

            tester_mode <= '0';
            tester_method <= x"8";
            tester_keyIn <= x"000000000000000017161514131211100f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"206572656874206e6568772065626972";
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 69 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
                                            
            wait for 10 ns; 

            tester_mode <= '0';
            tester_method <= x"9";
            tester_keyIn <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"74206e69206d6f6f6d69732061207369";
            tester_load <= '1'; wait for 1 ns; 
                tester_clock <= '1'; wait for 1 ns; 
                tester_clock <= '0'; wait for 1 ns;
            tester_load <= '0';
            for a in 0 to 72 loop
                tester_clock <= '1'; wait for 1ns;
                tester_clock <= '0'; wait for 1ns;
            end loop;
                                            
            wait for 10 ns; 
            
            --timeout
            wait for 1000 ms;    
        end process;          

end behaviour;