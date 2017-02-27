--library IEEE;
--use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
--use std.textio.all; 
--use work.printerlib.all;

--entity tester is
--end tester;

--architecture behaviour of tester is
---- //////// //////// //////// //////// //////// //////// //////// ////////
--    -- declare constants
--    constant messageLength: integer := 128;
--    constant keyLength: integer := 256;
--    constant maxCryptLoopCount: integer := 72;
    
--    -- declare component
--    component simon
--        port(
--            mode, clock: in std_logic;
--            keyIn: in std_logic_vector((keyLength-1) downto 0);
--            messageIn: in std_logic_vector((messageLength-1) downto 0);
--            messageOut: out std_logic_vector((messageLength-1) downto 0)
--        );
--    end component;

--    -- internal signals 
--    signal tester_mode, tester_clock: std_logic := '0';
--    signal tester_method: std_logic_vector(3 downto 0) := (others => '0');
--    signal tester_keyIn: std_logic_vector((keyLength-1) downto 0) := (others => '0');
--    signal tester_messageIn: std_logic_vector((messageLength-1) downto 0) := (others => '0');
--    signal tester_messageOut: std_logic_vector((messageLength-1) downto 0) := (others => '0');

---- //////// //////// //////// //////// //////// //////// //////// ////////
--    begin
--    -- connect component
--        mainComponent: simon port map(
--            mode => tester_mode, 
--			clock => tester_clock,
--            keyIn => tester_keyIn,
--            messageIn => tester_messageIn,
--            messageOut => tester_messageOut
--        );

--    -- run tests
--        process begin
--            tester_mode <= '0';
--            tester_keyIn <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
--            tester_messageIn <= x"74206e69206d6f6f6d69732061207369";
--            tester_clock <= '1'; wait for 1 ns; tester_clock <= '0'; wait for 1 ns;
            
--            tester_mode <= '1';
--            tester_keyIn <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
--            tester_messageIn <= x"8d2b5579afc8a3a03bf72a87efe7b868";
--            tester_clock <= '1'; wait for 1 ns; tester_clock <= '0'; wait for 1 ns;
			
--            for a in 0 to (maxCryptLoopCount-2) loop
--                tester_clock <= '1';
--                wait for 1ns;
--                tester_clock <= '0';
--                wait for 1ns;
--            end loop;
            
--            wait for 10ns;
            
--            -- results arrive
--            for a in 0 to 1 loop
--                tester_clock <= '1';
--                wait for 1ns;
--                tester_clock <= '0';
--                wait for 1ns;
--            end loop;  

--            --timeout
--            wait for 1000 ms;    
--        end process;          

--end behaviour;