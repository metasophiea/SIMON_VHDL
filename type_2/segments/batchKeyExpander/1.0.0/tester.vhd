library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; 
use work.printerlib.all;

entity tester is
end tester;

architecture behaviour of tester is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare components
    component batchKeyExpander
        port(
            method: in std_logic_vector(3 downto 0);
            Z: in std_logic_vector(61 downto 0);
            keyIn: in std_logic_vector(255 downto 0);
            keyOut: out std_logic_vector(255 downto 0)
        );
    end component;

    -- declare Z's
    signal Z_0: std_logic_vector(61 downto 0) := "11111010001001010110000111001101111101000100101011000011100110";
    signal Z_1: std_logic_vector(61 downto 0) := "10001110111110010011000010110101000111011111001001100001011010";
    signal Z_2: std_logic_vector(61 downto 0) := "10101111011100000011010010011000101000010001111110010110110011";
    signal Z_3: std_logic_vector(61 downto 0) := "11011011101011000110010111100000010010001010011100110100001111";
    signal Z_4: std_logic_vector(61 downto 0) := "11010001111001101011011000100000010111000011001010010011101111"; 
    
    -- internal signals
    signal tester_method: std_logic_vector(3 downto 0) := x"0";
    signal tester_Z: std_logic_vector(61 downto 0) := "00000000000000000000000000000000000000000000000000000000000000";
    signal tester_keyIn: std_logic_vector(255 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000" ;
    signal tester_keyOut: std_logic_vector(255 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000";
   
begin
    -- connect component
    mainComponent: batchKeyExpander port map(
        method => tester_method,
        Z => tester_Z,
        keyIn => tester_keyIn,
        keyOut => tester_keyOut
    );
    
    process begin
        tester_method <= x"9";
        tester_Z <= Z_4;
        tester_keyIn <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
        wait for 10 ns;
        print("tester::keyOut: "); logicPrint(tester_keyOut); flush;
        
        wait for 1000 ms;
        
    end process;

end behaviour;