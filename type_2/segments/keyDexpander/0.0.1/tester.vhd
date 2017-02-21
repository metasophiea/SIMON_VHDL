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
    component keyExpander
        port(
            method: in std_logic_vector(3 downto 0);
            Z: in std_logic_vector(61 downto 0);
            keyIn: in std_logic_vector(255 downto 0);
            keyOut: out std_logic_vector(255 downto 0) := (others => '0');
            returnZ: out std_logic_vector(61 downto 0) := (others => '0')
        );
    end component;
    
    component reverseKeyExpander
        port(
            method: in std_logic_vector(3 downto 0);
            Z: in std_logic_vector(61 downto 0);
            keyIn: in std_logic_vector(255 downto 0);
            keyOut: out std_logic_vector(255 downto 0) := (others => '0');
            returnZ: out std_logic_vector(61 downto 0) := (others => '0')
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
    signal tester_Z, tester_Z_expansionOut, tester_Z_dexpansionOut: std_logic_vector(61 downto 0) := "00000000000000000000000000000000000000000000000000000000000000";
    signal tester_keyIn, tester_key_expansionOut, tester_key_dexpansionOut: std_logic_vector(255 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000" ;
   
begin
    -- connect components
    expanderComponent: keyExpander port map(
        method => tester_method,        
        Z => tester_Z,
        returnZ => tester_Z_expansionOut,
        keyIn => tester_keyIn,
        keyOut => tester_key_expansionOut
    );
    
    dexpanderComponent: reverseKeyExpander port map(
        method => tester_method,        
        Z => tester_Z_expansionOut,
        returnZ => tester_Z_dexpansionOut,
        keyIn => tester_key_expansionOut,
        keyOut => tester_key_dexpansionOut
    );  
    
    process begin
        tester_method <= x"9";
        tester_Z <= Z_4;
        tester_keyIn <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
        wait for 10 ns;
        
        print("tester::keyIn:         "); logicPrint(tester_keyIn); flush;
        print("tester::expanded key:  "); logicPrint(tester_key_expansionOut); flush;
        print("tester::dexpanded key: "); logicPrint(tester_key_dexpansionOut); flush;  

        wait for 1000 ms;
        
    end process;

end behaviour;