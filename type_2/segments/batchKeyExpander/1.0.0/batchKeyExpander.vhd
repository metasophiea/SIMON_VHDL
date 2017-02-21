library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; 
use work.printerlib.all;

entity batchKeyExpander is
    port(
        method: in std_logic_vector(3 downto 0);
        Z: in std_logic_vector(61 downto 0);
        keyIn: in std_logic_vector(255 downto 0);
        keyOut: out std_logic_vector(255 downto 0)
    );
end batchKeyExpander;

architecture Behavioral of batchKeyExpander is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare constants
    constant maxCryptLoopCount : integer := 72;

    -- declare components
    component keyExpander is
        port(
            method: in std_logic_vector(3 downto 0);
            Z: in std_logic_vector(61 downto 0);
            keyIn: in std_logic_vector(255 downto 0);
            keyOut: out std_logic_vector(255 downto 0) := (others => '0');
            returnZ: out std_logic_vector(61 downto 0)
        );
    end component;
    
    -- internal signals
    type morphingZ_type is array (0 to (maxCryptLoopCount-1)) of std_logic_vector(61 downto 0);
    signal morphingZ: morphingZ_type := ( others => std_logic_vector(to_unsigned(0,62)) );

    type morphingKey_type is array (0 to (maxCryptLoopCount-1)) of std_logic_vector(255 downto 0);
    signal morphingKey: morphingKey_type := ( others => std_logic_vector(to_unsigned(0,256)) );
    
begin
    -- connect inputs and outputs
    morphingZ(0) <= Z;
    morphingKey(0) <= keyIn;
    keyOut <= morphingKey(maxCryptLoopCount-1);   
    
    -- generate and connect components
    keyExpansion_generation:for a in 0 to (maxCryptLoopCount-2) generate
        keyExpansion: keyExpander port map(
            method => method,        
            Z => morphingZ(a),
            returnZ => morphingZ(a+1),
            keyIn => morphingKey(a),
            keyOut => morphingKey(a+1)
        ); 
    end generate; 

end Behavioral;