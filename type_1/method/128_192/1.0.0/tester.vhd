library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; 
use work.printerlib.all;

-- Methods | messageLength/keyLength | keySegmentLength | keySegments | messageSegments | messageSegmentLength | cryptLoopCount | Zselect
-- 1000    | 128/192                 | 64               | 3           | 2               | 64                   | 69             | 3

entity tester is
end tester;

architecture behaviour of tester is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare constants
    constant messageLength: integer := 128;
    constant keyLength: integer := 192;
    
    -- declare component
    component simon
        port(
            mode: in std_logic;
            keyIn: in std_logic_vector((keyLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component;

    -- internal signals 
    signal tester_mode: std_logic := '0';
    signal tester_keyIn: std_logic_vector((keyLength-1) downto 0) := (others => '0');
    signal tester_messageIn: std_logic_vector((messageLength-1) downto 0) := (others => '0');
    signal tester_messageOut: std_logic_vector((messageLength-1) downto 0) := (others => '0');

    procedure printResults is begin 
        print("tester::mode:   "); if(tester_mode = '0') then print("encrypt"); else print("decrypt");end if; flush; 
        print("tester::key:    "); logicPrint(tester_keyIn); flush; 
        print("tester::sent:   "); logicPrint(tester_messageIn); flush; 
        print("tester::answer: "); logicPrint(tester_messageOut); flush; flush;
    end procedure;

begin
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- connect component
        mainComponent: simon port map(
            mode => tester_mode,
            keyIn => tester_keyIn,
            messageIn => tester_messageIn,
            messageOut => tester_messageOut
        );

    -- run tests
        process begin
            tester_mode <= '0';
            tester_keyIn <= x"17161514131211100f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"206572656874206e6568772065626972";
            wait for 10 ns;
            printResults;

            tester_mode <= '1';
            tester_keyIn <= x"17161514131211100f0e0d0c0b0a09080706050403020100";
            tester_messageIn <= x"c4ac61effcdc0d4f6c9c8d6e2597b85b";
            wait for 10 ns;
            printResults;

            --timeout
            wait for 1000 ms;    
        end process;          

end behaviour;