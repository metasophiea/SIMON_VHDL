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
            mode: in std_logic;
            method: in std_logic_vector(3 downto 0);
            keyIn: in std_logic_vector(255 downto 0);
            messageIn: in std_logic_vector(127 downto 0);
            messageOut: out std_logic_vector(127 downto 0)
        );
    end component;

    -- internal signals 
    signal tester_mode: std_logic := '0';
    signal tester_method: std_logic_vector(3 downto 0) := (others => '0');
    signal tester_keyIn: std_logic_vector(255 downto 0) := (others => '0');
    signal tester_messageIn: std_logic_vector(127 downto 0) := (others => '0');
    signal tester_messageOut: std_logic_vector(127 downto 0) := (others => '0');

    procedure printResults is begin 
        print("tester::method: "); logicPrint(tester_method); flush; 
        print("tester::mode:   "); if(tester_mode = '0') then print("encrypt"); else print("decrypt");end if; flush; 
        print("tester::key:    "); logicPrint(tester_keyIn); flush; 
        print("tester::sent:   "); logicPrint(tester_messageIn); flush; 
        print("tester::answer: "); logicPrint(tester_messageOut); flush; flush;
    end procedure;

-- //////// //////// //////// //////// //////// //////// //////// ////////
    begin
    -- connect component
        mainComponent: simon port map(
            mode => tester_mode,
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
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"0";
            tester_keyIn <= x"0000000000000000000000000000000000000000000000001918111009080100";
            tester_messageIn <= x"000000000000000000000000c69be9bb";
            wait for 10 ns;
            printResults;

            tester_mode <= '0';
            tester_method <= x"1";
            tester_keyIn <= x"00000000000000000000000000000000000000000000001211100a0908020100";
            tester_messageIn <= x"000000000000000000006120676e696c";
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"1";
            tester_keyIn <= x"00000000000000000000000000000000000000000000001211100a0908020100";
            tester_messageIn <= x"00000000000000000000dae5ac292cac";
            wait for 10 ns;
            printResults;

            tester_mode <= '0';
            tester_method <= x"2";
            tester_keyIn <= x"00000000000000000000000000000000000000001a19181211100a0908020100";
            tester_messageIn <= x"0000000000000000000072696320646e";
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"2";
            tester_keyIn <= x"00000000000000000000000000000000000000001a19181211100a0908020100";
            tester_messageIn <= x"000000000000000000006e06a5acf156";
            wait for 10 ns;
            printResults;

            tester_mode <= '0';
            tester_method <= x"3";
            tester_keyIn <= x"0000000000000000000000000000000000000000131211100b0a090803020100";
            tester_messageIn <= x"00000000000000006f7220676e696c63";
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"3";
            tester_keyIn <= x"0000000000000000000000000000000000000000131211100b0a090803020100";
            tester_messageIn <= x"00000000000000005ca2e27f111a8fc8";
            wait for 10 ns;
            printResults;

            tester_mode <= '0';
            tester_method <= x"4";
            tester_keyIn <= x"000000000000000000000000000000001b1a1918131211100b0a090803020100";      
            tester_messageIn <= x"0000000000000000656b696c20646e75"; 
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"4";
            tester_keyIn <= x"000000000000000000000000000000001b1a1918131211100b0a090803020100";
            tester_messageIn <= x"000000000000000044c8fc20b9dfa07a"; 
            wait for 10 ns;
            printResults;
            
            tester_mode <= '0';
            tester_method <= x"5";
            tester_keyIn <= x"00000000000000000000000000000000000000000d0c0b0a0908050403020100";
            tester_messageIn <= x"000000002072616c6c69702065687420";
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"5";
            tester_keyIn <= x"00000000000000000000000000000000000000000d0c0b0a0908050403020100";
            tester_messageIn <= x"00000000602807a462b469063d8ff082";
            wait for 10 ns;
            printResults;

            tester_mode <= '0';
            tester_method <= x"6";
            tester_keyIn <= x"00000000000000000000000000001514131211100d0c0b0a0908050403020100";
            tester_messageIn <= x"0000000074616874207473756420666f";
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"6";
            tester_keyIn <= x"00000000000000000000000000001514131211100d0c0b0a0908050403020100";
            tester_messageIn <= x"00000000ecad1c6c451e3f59c5db1ae9";
            wait for 10 ns;
            printResults;
            
            tester_mode <= '0';
            tester_method <= x"7";
            tester_keyIn <= x"000000000000000000000000000000000f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"63736564207372656c6c657661727420";
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"7";
            tester_keyIn <= x"000000000000000000000000000000000f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"49681b1e1e54fe3f65aa832af84e0bbc";
            wait for 10 ns;
            printResults;

            tester_mode <= '0';
            tester_method <= x"8";
            tester_keyIn <= x"000000000000000017161514131211100f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"206572656874206e6568772065626972";
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"8";
            tester_keyIn <= x"000000000000000017161514131211100f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"c4ac61effcdc0d4f6c9c8d6e2597b85b";
            wait for 10 ns;
            printResults;

            tester_mode <= '0';
            tester_method <= x"9";
            tester_keyIn <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"74206e69206d6f6f6d69732061207369";
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_method <= x"9";
            tester_keyIn <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"8d2b5579afc8a3a03bf72a87efe7b868";
            wait for 10 ns;
            printResults;

            --timeout
            wait for 1000 ms;    
        end process;          

end behaviour;